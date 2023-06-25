import 'package:equatable/equatable.dart';

abstract class MnemonicGenerationState extends Equatable {
  const MnemonicGenerationState();

  @override
  List<Object?> get props => [];
}

class MnemonicGenerationInitial extends MnemonicGenerationState {}

class MnemonicGenerationSuccess extends MnemonicGenerationState {
  const MnemonicGenerationSuccess(this.mnemonic);
  final String mnemonic;
  //final bool isBackedUpByUser;

  @override
  List<Object?> get props => [mnemonic];
}

class MnemonicGenerationFailure extends MnemonicGenerationState {}

class MnemonicStoreSuccess extends MnemonicGenerationState {
  const MnemonicStoreSuccess();
}

class MnemonicStoreFailure extends MnemonicGenerationState {
  const MnemonicStoreFailure(this.mnemonic);
  final String mnemonic;
  //final bool isBackedUpByUser;

  @override
  List<Object?> get props => [mnemonic];
}
