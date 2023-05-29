import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_state.dart';
import 'package:seed_repository/seed_repository.dart';

class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  MnemonicBloc({required SeedRepository seedRepository})
      : _seedRepository = seedRepository,
        super(MnemonicInitial()) {
    on<MnemonicGenerationPressed>(_onGenerationPressed);
    on<MnemonicConfirmed>(_onConfirmed);
  }

  final SeedRepository _seedRepository;

  Future<void> _onGenerationPressed(
    MnemonicGenerationPressed event,
    Emitter<MnemonicState> emit,
  ) async {
    try {
      final mnemonic = await _seedRepository.create24WordMnemonic();
      emit(MnemonicSuccess(mnemonic.asString()));
    } catch (e) {
      emit(MnemonicFailure());
    }
  }

  Future<void> _onConfirmed(
    MnemonicConfirmed event,
    Emitter<MnemonicState> emit,
  ) async {
    // The only states that have a mnemonic to be confirmed are MnemonicSucces and MnemonicStoreFailure
    // Other states do not have a mnemonic available.
    if (state is MnemonicSuccess || state is MnemonicStoreFailure) {
      final mnemonic = state is MnemonicSuccess
          ? (state as MnemonicSuccess).mnemonic
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
