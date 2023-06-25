import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/wallet_recovery/wallet_recovery_bloc.dart';

class WalletRecoveryScreen extends StatelessWidget {
  const WalletRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WalletRecoveryBloc(),
      child: const Scaffold(
        body: Text('<<<INPUT MNEMONIC HERE PLACEHOLDER>>>'),
      ),
    );
  }
}
