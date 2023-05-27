import 'dart:async';

import 'package:bdk_flutter/bdk_flutter.dart';
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

  Future<FutureOr<void>> _onGenerationPressed(
    MnemonicGenerationPressed event,
    Emitter<MnemonicState> emit,
  ) async {
    try {
      final mnemonic = await _seedRepository.create24WordMnemonic();
      print(await mnemonic.toLightningSeed(Network.Regtest));
      emit(MnemonicSuccess(mnemonic: mnemonic.asString()));
    } catch (e) {
      emit(MnemonicFailure());
    }
  }

  Future<void> _onConfirmed(
    MnemonicConfirmed event,
    Emitter<MnemonicState> emit,
  ) async {
    try {
      // Store the mnemonic in secure storage.
      await _seedRepository.storeMnemonic(state.mnemonic);
      emit(MnemonicStoreSuccess(mnemonic: state.mnemonic));
    } catch (e) {
      emit(MnemonicStoreFailure(mnemonic: state.mnemonic));
    }
  }
}
