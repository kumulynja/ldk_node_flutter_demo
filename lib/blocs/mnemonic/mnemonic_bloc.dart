import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_state.dart';
import 'package:bdk_flutter/bdk_flutter.dart';

class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  MnemonicBloc() : super(MnemonicInitial()) {
    on<MnemonicGenerationPressed>(_onGenerationPressed);
  }

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
}
