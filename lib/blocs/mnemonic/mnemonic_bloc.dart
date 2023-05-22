import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_state.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:mnemonic_repository/mnemonic_repository.dart';

class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  MnemonicBloc({required MnemonicRepository mnemonicRepository})
      : _mnemonicRepository = mnemonicRepository,
        super(MnemonicInitial()) {
    on<MnemonicGenerationPressed>(_onGenerationPressed);
    on<MnemonicConfirmed>(_onConfirmed);
  }

  final MnemonicRepository _mnemonicRepository;

  Future<FutureOr<void>> _onGenerationPressed(
    MnemonicGenerationPressed event,
    Emitter<MnemonicState> emit,
  ) async {
    print("_onGenerationPressed");
    try {
      final mnemonic = await Mnemonic.create(WordCount.Words24);
      print("Mnemonic: ${mnemonic.asString()}");
      emit(MnemonicSuccess(mnemonic: mnemonic.asString()));
    } catch (e) {
      print("Error: $e");
      emit(MnemonicFailure());
    }
  }

  Future<void> _onConfirmed(
    MnemonicConfirmed event,
    Emitter<MnemonicState> emit,
  ) async {
    print("_onMnemonicConfirmed");
    try {
      // Store the mnemonic in secure storage.
      await _mnemonicRepository.storeMnemonic(state.mnemonic);
      print("AFTER STOREMNEMONIC");
      emit(MnemonicStoreSuccess(mnemonic: state.mnemonic));
    } catch (e) {
      print("Error: $e");
      emit(MnemonicStoreFailure(mnemonic: state.mnemonic));
    }
  }
}
