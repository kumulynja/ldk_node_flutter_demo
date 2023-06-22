import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_state.dart';
import 'package:ldk_node_flutter_demo/blocs/network/network_cubit.dart';
import 'package:seed_repository/seed_repository.dart';

class MnemonicScreen extends StatelessWidget {
  const MnemonicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MnemonicBloc(
        seedRepository: RepositoryProvider.of<SeedRepository>(context),
      )..add(MnemonicGenerationStarted()),
      child: Scaffold(
        body: BlocListener<MnemonicBloc, MnemonicState>(
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
          child: BlocBuilder<MnemonicBloc, MnemonicState>(
            builder: (context, state) => switch (state) {
              MnemonicInitial() ||
              MnemonicStoreSuccess() =>
                const Center(child: CircularProgressIndicator()),
              MnemonicSuccess() =>
                _buildMnemonicScreen((state).mnemonic, 'Continue', () {
                  context.read<MnemonicBloc>().add(MnemonicConfirmed());
                }, 'Make sure you have written down and safely stored your mnemonic before continuing.',
                    context),
              MnemonicFailure() => _buildMnemonicScreen(
                    'Wallet creation failed.', 'Try again', () {
                  context.read<MnemonicBloc>().add(MnemonicGenerationRetried());
                }, 'Failed to generate a mnemonic. Please try again.', context),
              MnemonicStoreFailure() =>
                _buildMnemonicScreen((state).mnemonic, 'Continue', () {
                  context.read<MnemonicBloc>().add(MnemonicConfirmed());
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

  Widget _buildMnemonicScreen(String mnemonic, String buttonText,
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
