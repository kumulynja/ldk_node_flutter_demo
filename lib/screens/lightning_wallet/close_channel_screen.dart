import 'package:flutter/material.dart';

class CloseChannelScreen extends StatelessWidget {
  const CloseChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Channel closing'),
      ),
      body: Center(
        child: Text(
          'Hey, you can implement this screen!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
