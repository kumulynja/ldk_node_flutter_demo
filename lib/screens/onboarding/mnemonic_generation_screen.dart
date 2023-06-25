import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/bloc/mnemonic_generation/mnemonic_generation_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/mnemonic_generation/mnemonic_generation_event.dart';
import 'package:ldk_node_flutter_demo/bloc/mnemonic_generation/mnemonic_generation_state.dart';
import 'package:ldk_node_flutter_demo/bloc/network/network_cubit.dart';
import 'package:seed_repository/seed_repository.dart';

class MnemonicGenerationScreen extends StatelessWidget {
  const MnemonicGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MnemonicGenerationBloc(
        seedRepository: RepositoryProvider.of<SeedRepository>(context),
      )..add(MnemonicGenerationStarted()),
      child: Scaffold(
        body: BlocListener<MnemonicGenerationBloc, MnemonicGenerationState>(
          // Separate consequences of changes in the bloc, like navigation here,
          //  in a BlocListener so the BlocBuilder is only concerned with UI.
          listener: (context, state) {
            if (state is MnemonicStoreSuccess) {
              // The mnemonic is stored successfully
              // Start the Lightning node and navigate to the lightning wallet's
              //  home screen
              context.read<LightningNodeBloc>().add(
                    LightningNodeStarted(
                      network: context.read<NetworkCubit>().state,
                    ),
                  );
              context.goNamed('lightning');
            }
          },
          child: BlocBuilder<MnemonicGenerationBloc, MnemonicGenerationState>(
            builder: (context, state) => switch (state) {
              MnemonicGenerationInitial() ||
              MnemonicStoreSuccess() =>
                const Center(child: CircularProgressIndicator()),
              MnemonicGenerationSuccess() => _buildMnemonicGenerationScreen(
                    (state).mnemonic, 'Continue', () {
                  context
                      .read<MnemonicGenerationBloc>()
                      .add(MnemonicConfirmed());
                }, 'Make sure you have written down and safely stored your mnemonic before continuing.',
                    context),
              MnemonicGenerationFailure() => _buildMnemonicGenerationScreen(
                    'Wallet creation failed.', 'Try again', () {
                  context
                      .read<MnemonicGenerationBloc>()
                      .add(MnemonicGenerationRetried());
                }, 'Failed to generate a mnemonic. Please try again.', context),
              MnemonicStoreFailure() => _buildMnemonicGenerationScreen(
                    (state).mnemonic, 'Continue', () {
                  context
                      .read<MnemonicGenerationBloc>()
                      .add(MnemonicConfirmed());
                }, 'Failed to store the mnemonic. Please try again.', context),
              _ => throw const FormatException(
                  'Unknow state in mnemonic bloc.',
                ),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMnemonicGenerationScreen(String mnemonic, String buttonText,
      VoidCallback onPressed, String message, BuildContext context) {
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
                mnemonic,
                style: Theme.of(context).textTheme.displaySmall,
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
                  onPressed: onPressed,
                  child: Text(
                    buttonText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
