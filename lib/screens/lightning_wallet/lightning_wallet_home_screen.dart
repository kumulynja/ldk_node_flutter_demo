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
  final List<bool> _isOpen = [
    false,
    false,
    true
  ]; // Start with Transaction History open

  void _togglePanel(int index) {
    // Make sure only one panel is open at a time
    setState(() {
      for (int i = 0; i < _isOpen.length; i++) {
        if (i != index) {
          _isOpen[i] = false;
        } else {
          _isOpen[i] = !_isOpen[i];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightningNodeBloc = BlocProvider.of<LightningNodeBloc>(context);
    lightningNodeBloc.add(const LightningNodeRefreshed());

    return Scaffold(
      body: BlocBuilder<LightningNodeBloc, LightningNodeState>(
        bloc: lightningNodeBloc,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            WalletInfoContainer(
              walletName: 'Lightning Wallet',
              containerColor: Theme.of(context).colorScheme.surface,
              isSyncing: state is! LightningNodeRunSuccess,
              onRefresh: () => lightningNodeBloc.add(
                const LightningNodeRefreshed(),
              ),
              balance: state is LightningNodeRunSuccess ? state.balance : null,
              unit: 'sats',
              balanceLabel: 'spendable',
              network:
                  state is LightningNodeRunSuccess ? state.network.name : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.only(top: 0),
                children: [
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      _togglePanel(index);
                    },
                    children: [
                      ExpansionPanel(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return const Text('Funding Actions');
                        },
                        body:
                            const LightningFundingActions(), // Custom Widget for Funding Actions
                        isExpanded: _isOpen[0],
                        canTapOnHeader: true,
                      ),
                      ExpansionPanel(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return const Text('Payment Actions');
                        },
                        body:
                            const LightningPaymentActions(), // Custom Widget for Payment Actions
                        isExpanded: _isOpen[1],
                        canTapOnHeader: true,
                      ),
                      ExpansionPanel(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return const Text('Transaction History');
                        },
                        body:
                            const TransactionHistory(), // Custom Widget for Transaction History
                        isExpanded: _isOpen[2],
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
