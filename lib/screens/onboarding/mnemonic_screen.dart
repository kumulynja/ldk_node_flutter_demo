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
      create: (BuildContext context) {
        final bloc = MnemonicBloc();
        bloc.add(MnemonicGenerationPressed());
        return bloc;
      },
      child: Scaffold(
        body: BlocBuilder<MnemonicBloc, MnemonicState>(
          buildWhen: (previous, current) => current.mnemonic != "",
          builder: (context, state) => Text(state.mnemonic),
        ),
      ),
    );
  }
}
