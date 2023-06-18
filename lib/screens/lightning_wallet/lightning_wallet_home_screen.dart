import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:ldk_node_flutter_demo/widgets/transaction_history.dart';
import 'package:ldk_node_flutter_demo/widgets/wallet_info_container.dart';
import 'package:ldk_node_flutter_demo/widgets/lightning_funding_actions.dart';
import 'package:ldk_node_flutter_demo/widgets/lightning_payment_actions.dart';

class LightningWalletHomeScreen extends StatefulWidget {
  const LightningWalletHomeScreen({Key? key}) : super(key: key);

  @override
  LightningWalletHomeScreenState createState() =>
      LightningWalletHomeScreenState();
}

class LightningWalletHomeScreenState extends State<LightningWalletHomeScreen> {
  late final LightningNodeBloc _lightningNodeBloc;
  final List<bool> _isOpen = [true, true, true];

  @override
  void initState() {
    super.initState();
    _lightningNodeBloc = BlocProvider.of<LightningNodeBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Perform actions every time the screen comes into view
    _lightningNodeBloc.add(const LightningNodeRefreshed());
  }

  void _togglePanel(int index) {
    setState(() {
      // The commented lines are if you want to make sure
      //  only one panel is open at a time
      //for (int i = 0; i < _isOpen.length; i++) {
      //if (i != index) {
      //_isOpen[i] = false;
      //} else {
      _isOpen[index] = !_isOpen[index];
      //}
      // }
    });
  }

  ExpansionPanel _buildExpansionPanel(int index, String title, Widget body) {
    return ExpansionPanel(
      backgroundColor: Theme.of(context).colorScheme.background,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(title),
        );
      },
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: body,
      ),
      isExpanded: _isOpen[index],
      canTapOnHeader: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LightningNodeBloc, LightningNodeState>(
        bloc: _lightningNodeBloc,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            WalletInfoContainer(
              walletName: 'Lightning Wallet',
              containerColor: Theme.of(context).colorScheme.surface,
              isSyncing: state is! LightningNodeRunSuccess,
              onRefresh: () => _lightningNodeBloc.add(
                const LightningNodeRefreshed(),
              ),
              balance: state is LightningNodeRunSuccess
                  ? state.totalOutBoundCapacitySat
                  : null,
              unit: 'sats',
              balanceLabel: 'spendable',
              network:
                  state is LightningNodeRunSuccess ? state.network.name : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    _togglePanel(index);
                  },
                  children: [
                    _buildExpansionPanel(
                      0,
                      'Liquidity',
                      LightningFundingActions(
                        confirmedOnChainBalance:
                            state is LightningNodeRunSuccess
                                ? state.confirmedOnChainBalanceBtc
                                : 0,
                        nrOfActiveChannels: state is LightningNodeRunSuccess
                            ? state.activeChannelCount
                            : 0,
                        nrOfInactiveChannels: state is LightningNodeRunSuccess
                            ? state.inActiveChannelCount
                            : 0,
                      ),
                    ),
                    _buildExpansionPanel(
                      1,
                      'Payments',
                      const LightningPaymentActions(),
                    ),
                    _buildExpansionPanel(
                      2,
                      'Transaction History',
                      const TransactionHistory(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
