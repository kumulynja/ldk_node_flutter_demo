import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/mnemonic_generation/mnemonic_generation_event.dart';
import 'package:ldk_node_flutter_demo/bloc/mnemonic_generation/mnemonic_generation_state.dart';
import 'package:seed_repository/seed_repository.dart';

class MnemonicGenerationBloc
    extends Bloc<MnemonicGenerationEvent, MnemonicGenerationState> {
  MnemonicGenerationBloc({required SeedRepository seedRepository})
      : _seedRepository = seedRepository,
        super(MnemonicGenerationInitial()) {
    on<MnemonicGenerationStarted>(_onGeneration);
    on<MnemonicGenerationRetried>(_onGeneration);
    on<MnemonicConfirmed>(_onConfirmed);
  }

  final SeedRepository _seedRepository;

  Future<void> _onGeneration(
    MnemonicGenerationEvent event,
    Emitter<MnemonicGenerationState> emit,
  ) async {
    try {
      final mnemonic = await _seedRepository.create24WordMnemonic();
      emit(MnemonicGenerationSuccess(mnemonic.asString()));
    } catch (e) {
      emit(MnemonicGenerationFailure());
    }
  }

  Future<void> _onConfirmed(
    MnemonicConfirmed event,
    Emitter<MnemonicGenerationState> emit,
  ) async {
    // The only states that have a mnemonic to be confirmed are MnemonicSucces and MnemonicStoreFailure
    // Other states do not have a mnemonic available.
    if (state is MnemonicGenerationSuccess || state is MnemonicStoreFailure) {
      final mnemonic = state is MnemonicGenerationSuccess
          ? (state as MnemonicGenerationSuccess).mnemonic
          : (state as MnemonicStoreFailure).mnemonic;
      try {
        // Store the mnemonic in secure storage.
        await _seedRepository.storeMnemonic(mnemonic);
        emit(const MnemonicStoreSuccess());
      } catch (e) {
        emit(MnemonicStoreFailure(mnemonic));
      }
    }
  }
}
