import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateWalletScreen extends StatelessWidget {
  const CreateWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/images/ldk-banner.png',
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    FilledButton(
                      onPressed: () async {
                        GoRouter.of(context).pushNamed('mnemonic');
                      },
                      child: const Text(
                        'Create wallet',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed('recovery');
                      },
                      child: const Text('Restore funds'),
                    ),
                    Text(
                      "(With your 24 words)",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
