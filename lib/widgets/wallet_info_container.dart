import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_balance/lightning_balance_cubit.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class WalletInfoContainer extends StatelessWidget {
  final LightningNodeState lightningNodeState;
  final LightningNodeRepository lightningNodeRepository;

  const WalletInfoContainer({
    super.key,
    required this.lightningNodeState,
    required this.lightningNodeRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x32171717),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Lightning Wallet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: lightningNodeState is LightningNodeRunSuccess
                        ? BlocBuilder<BalanceCubit, int>(
                            bloc: BalanceCubit(
                              lightningNodeRepository: lightningNodeRepository,
                            ),
                            builder: (BuildContext context, state) {
                              return Text(
                                '$state SAT',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.start,
                              );
                            },
                          )
                        : const CircularProgressIndicator(),
                  ),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 4),
                      child: Text(
                        'spendable',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.start,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                      child: Text(
                        'Network',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      lightningNodeState is LightningNodeRunSuccess
                          ? (lightningNodeState as LightningNodeRunSuccess)
                              .network
                              .name
                          : '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ]),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                        child: Text(
                          'Node Id',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          lightningNodeState is LightningNodeRunSuccess
                              ? (lightningNodeState as LightningNodeRunSuccess)
                                  .nodeId
                              : '',
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
