import 'package:flutter/material.dart';

class LightningPaymentActions extends StatelessWidget {
  const LightningPaymentActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: const Icon(Icons.arrow_downward),
          title: const Text('Receive'),
          onTap: () {
            print("Receive tapped");
            // Use Navigator.push() here to navigate to the screen for this action
          },
        ),
        ListTile(
          leading: const Icon(Icons.qr_code),
          title: const Text('Pay invoice'),
          onTap: () {
            print("Pay invoice tapped");
            // Use Navigator.push() here to navigate to the screen for this action
          },
        ),
        ListTile(
          leading: const Icon(Icons.send),
          title: const Text('Send spontaneously'),
          onTap: () {
            print("Send spontaneously tapped");
            // Use Navigator.push() here to navigate to the screen for this action
          },
        ),
        const ListTile(
          leading: Icon(Icons.access_time),
          title: Text('Bolt12 (coming soon...)'),
          enabled: false, // This makes the ListTile visually disabled.
        ),
      ],
    );
  }
}
