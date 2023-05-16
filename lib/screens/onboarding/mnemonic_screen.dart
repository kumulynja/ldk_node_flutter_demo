import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_state.dart';

class MnemonicScreen extends StatelessWidget {
  const MnemonicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MnemonicBloc()..add(MnemonicGenerationPressed()),
      child: Scaffold(
        body: BlocBuilder<MnemonicBloc, MnemonicState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case MnemonicInitial:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case MnemonicSuccess:
                return Center(
                  child: Text(state.mnemonic),
                );
              case MnemonicFailure:
                return const Center(
                  child: Text('failed to generate a mnemonic.'),
                );
              default:
                throw const FormatException('Unknow state in mnemonic bloc.');
            }
          },
        ),
      ),
    );
  }
}
