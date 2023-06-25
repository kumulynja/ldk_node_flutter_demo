import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LightningFundingActions extends StatelessWidget {
  final double confirmedOnChainBalance;
  final int nrOfActiveChannels;
  final int nrOfInactiveChannels;

  const LightningFundingActions({
    super.key,
    required this.confirmedOnChainBalance,
    required this.nrOfActiveChannels,
    required this.nrOfInactiveChannels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 16, // space between columns
          runSpacing: 16, // space between rows
          children: [
            buildActionColumn(
              '$confirmedOnChainBalance',
              'BTC',
              'Fund',
              () => GoRouter.of(context).pushNamed('on-chain-funding'),
            ),
            buildActionColumn(
              '$nrOfActiveChannels',
              'Active channels',
              'Open channel',
              () => GoRouter.of(context).pushNamed('channel-opening'),
            ),
            buildActionColumn(
              '$nrOfInactiveChannels',
              'Inactive channels',
              'Close channel',
              () => GoRouter.of(context).pushNamed('channel-closing'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildActionColumn(
    String amount,
    String label,
    String buttonText,
    VoidCallback onButtonPressed,
  ) {
    return Column(
      children: [
        Text(amount),
        Text(label),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onButtonPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
