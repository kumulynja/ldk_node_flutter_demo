import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_event.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_state.dart';

class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  MnemonicBloc() : super(const MnemonicInitial()) {
    on<MnemonicGenerationPressed>(_onGenerationPressed);
  }

  FutureOr<void> _onGenerationPressed(
      MnemonicGenerationPressed event, Emitter<MnemonicState> emit) {
    emit(const MnemonicGenerationInProgress());
    const mnemonic = "sdjsd";
    emit(const MnemonicGenerationSuccess(mnemonic: mnemonic));
  }
}
