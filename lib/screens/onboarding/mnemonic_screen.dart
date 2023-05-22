import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_state.dart';
import 'package:mnemonic_repository/mnemonic_repository.dart';

class MnemonicScreen extends StatelessWidget {
  const MnemonicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MnemonicBloc(
        mnemonicRepository: RepositoryProvider.of<MnemonicRepository>(context),
      )..add(MnemonicGenerationPressed()),
      child: Scaffold(
        body: BlocBuilder<MnemonicBloc, MnemonicState>(
          builder: (context, state) {
            if (state is MnemonicInitial) {
              return const CircularProgressIndicator();
            }
            if (state is MnemonicStoreSuccess) {
              // The mnemonic is stored successfully
              context.goNamed('home');
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        state.mnemonic.isNotEmpty
                            ? state.mnemonic
                            : "Failed to generate mnemonic.",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        FilledButton(
                          onPressed: state.mnemonic.isNotEmpty
                              ? () {
                                  context
                                      .read<MnemonicBloc>()
                                      .add(MnemonicConfirmed());
                                }
                              : null, // null makes the button disabled
                          child: const Text(
                            'Continue',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: switch (state.runtimeType) {
                            MnemonicSuccess || MnemonicStoreSuccess => Text(
                                "Make sure you have written down and safely stored your mnemonic before continuing.",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            MnemonicFailure => Text(
                                "Failed to generate a mnemonic. Go back and try again.",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            MnemonicStoreFailure => Text(
                                "Failed to store the mnemonic. Try again...",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            _ => throw const FormatException(
                                'Unknow state in mnemonic bloc.',
                              ),
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
