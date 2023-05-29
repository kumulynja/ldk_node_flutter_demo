import 'package:equatable/equatable.dart';

abstract class MnemonicState extends Equatable {
  const MnemonicState();

  @override
  List<Object?> get props => [];
}

class MnemonicInitial extends MnemonicState {}

class MnemonicSuccess extends MnemonicState {
  const MnemonicSuccess(this.mnemonic);
  final String mnemonic;
  //final bool isBackedUpByUser;

  @override
  List<Object?> get props => [mnemonic];
}

class MnemonicFailure extends MnemonicState {}

class MnemonicStoreSuccess extends MnemonicState {
  const MnemonicStoreSuccess();
}

class MnemonicStoreFailure extends MnemonicState {
  const MnemonicStoreFailure(this.mnemonic);
  final String mnemonic;
  //final bool isBackedUpByUser;

  @override
  List<Object?> get props => [mnemonic];
}
