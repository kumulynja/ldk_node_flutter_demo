import 'package:flutter/material.dart';

class LightningFundingActions extends StatelessWidget {
  const LightningFundingActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 16, // space between columns
          runSpacing: 16, // space between rows
          children: [
            buildActionColumn("0.0001", "Bitcoin", "Fund"),
            buildActionColumn("1", "Active channels", "Open channel"),
            buildActionColumn("0", "Inactive channels", "Close channel"),
          ],
        ),
      ],
    );
  }

  Widget buildActionColumn(String amount, String label, String buttonText) {
    return Column(
      children: [
        Text(amount),
        Text(label),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text(buttonText),
        ),
      ],
    );
  }
}
