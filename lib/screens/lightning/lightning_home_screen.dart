import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_state.dart';
import 'package:ldk_node_flutter_demo/widgets/transaction_history.dart';
import 'package:ldk_node_flutter_demo/widgets/wallet_info_container.dart';
import 'package:ldk_node_flutter_demo/widgets/lightning_funding_actions.dart';
import 'package:ldk_node_flutter_demo/widgets/lightning_payment_actions.dart';

class LightningHomeScreen extends StatefulWidget {
  const LightningHomeScreen({Key? key}) : super(key: key);

  @override
  LightningHomeScreenState createState() => LightningHomeScreenState();
}

class LightningHomeScreenState extends State<LightningHomeScreen> {
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
              containerColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
              isSyncing: state is! LightningNodeRunSuccess,
              infoPopupContent: _WalletInfoPopupContent(
                nodeId: state is LightningNodeRunSuccess ? state.nodeId : "",
                listeningIp:
                    state is LightningNodeRunSuccess ? state.listeningIp : null,
                listeningPort: state is LightningNodeRunSuccess
                    ? state.listeningPort
                    : null,
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
              child: RefreshIndicator(
                onRefresh: () async {
                  final completer = Completer<void>();
                  _lightningNodeBloc.add(
                    const LightningNodeRefreshed(),
                  );
                  // Complete the completer inmediately just for testing
                  //  in a real app you would wait for the bloc to emit a state
                  //  For example the LightningNodeRefreshed event could change
                  //  the state to LightningNodeRefreshing and then the
                  //  LightningNodeRefreshing state could change to
                  //  LightningNodeRunSuccess again and then you would complete the completer.
                  //  This could be done with a stream subscription to the bloc.
                  //  Make sure to cancel the subscription too after completing the completer.
                  completer.complete();
                  return completer.future;
                },
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
                                  ? state.totalOnChainBalanceBtc
                                  : 0,
                          nrOfActiveChannels: state is LightningNodeRunSuccess
                              ? state.activeChannelCount
                              : 0,
                          nrOfInactiveChannels: state is LightningNodeRunSuccess
                              ? state.inactiveChannelCount
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
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletInfoPopupContent extends StatelessWidget {
  final String nodeId;
  final String? listeningIp;
  final int? listeningPort;

  const _WalletInfoPopupContent({
    Key? key,
    required this.nodeId,
    this.listeningIp,
    this.listeningPort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LightningNodeBloc, LightningNodeState>(
      builder: (context, state) {
        if (state is LightningNodeRunSuccess) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning,
                          color: Theme.of(context).colorScheme.onPrimary),
                      Text(
                        'This Lightning wallet is a demo app to show the basics of using LDK Node in a Flutter app.'
                        'It is for demonstration purposes only and not meant to be used in production or with real money.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your running LDK Node Information:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: nodeId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Node ID copied to clipboard")),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Node ID: $nodeId',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: null,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: listeningIp ?? ''));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Listening IP copied to clipboard")),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Listening IP: ${listeningIp ?? "Not available"}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: null,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: listeningPort.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Listening Port copied to clipboard")),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Listening Port: ${listeningPort?.toString() ?? "Not available"}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: null,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'A special thanks to @BitcoinZavior for the great Flutter packages and guidance and to all LDK contributors and the people at Spiral making it all happen.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
