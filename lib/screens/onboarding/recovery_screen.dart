import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/recovery/recovery_bloc.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RecoveryBloc(),
      child: const Scaffold(
        body: Text("INPUT MNEMONIC HERE"),
      ),
    );
  }
}
