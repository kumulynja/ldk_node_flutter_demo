import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          title: const Text('Generate invoice'),
          onTap: () => GoRouter.of(context).pushNamed('invoice'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18.0),
        ),
        ListTile(
          leading: const Icon(Icons.qr_code),
          title: const Text('Pay invoice'),
          onTap: () => GoRouter.of(context).pushNamed('pay'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18.0),
        ),
        ListTile(
          leading: const Icon(Icons.send),
          title: const Text('Send spontaneously'),
          onTap: () => GoRouter.of(context).pushNamed('send'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18.0),
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
