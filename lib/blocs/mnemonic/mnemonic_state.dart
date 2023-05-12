import 'package:equatable/equatable.dart';

abstract class MnemonicState extends Equatable {
  const MnemonicState({this.mnemonic});
  final String? mnemonic;

  @override
  List<Object?> get props => [mnemonic];
}

class MnemonicInitial extends MnemonicState {
  const MnemonicInitial();
}

class MnemonicGenerationInProgress extends MnemonicState {
  const MnemonicGenerationInProgress();
}

class MnemonicGenerationSuccess extends MnemonicState {
  const MnemonicGenerationSuccess({required String mnemonic})
      : super(mnemonic: mnemonic);
}

class MnemonicGenerationFailure extends MnemonicState {}

class MnemonicInputSuccess extends MnemonicState {}

class MnemonicInputFailure extends MnemonicState {}

class MnemonicStoreSuccess extends MnemonicState {}

class MnemonicStoreFailure extends MnemonicState {}
