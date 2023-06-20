import 'package:flutter/material.dart';

class WalletInfoContainer extends StatelessWidget {
  final String walletName;
  final Color containerColor;
  final Color textColor;
  final bool isSyncing;
  final VoidCallback? onRefresh;
  final double? balance;
  final String? unit;
  final String?
      balanceLabel; // e.j. 'spendable' for Lightning, 'saved' for Bitcoin
  final String? network;

  const WalletInfoContainer({
    super.key,
    required this.walletName,
    required this.containerColor,
    required this.textColor,
    this.isSyncing = false,
    this.balance,
    this.unit,
    this.balanceLabel,
    this.network,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x32171717),
            offset: Offset(0, 2),
          )
        ],
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
                        walletName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  onRefresh != null
                      ? IconButton(
                          icon: const Icon(Icons.refresh),
                          color: textColor,
                          onPressed: onRefresh,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            isSyncing
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: Text(
                            '${balance?.round()} $unit',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: textColor,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 0, 0, 4),
                            child: Text(
                              balanceLabel ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: textColor,
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
                        network != null ? 'Network' : '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      network ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: textColor,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
