import 'package:equatable/equatable.dart';

abstract class MnemonicState extends Equatable {
  const MnemonicState({this.mnemonic = ""});
  final String mnemonic;
  //final bool isWrittenDownByUser;

  @override
  List<Object?> get props => [mnemonic];
}

class MnemonicInitial extends MnemonicState {}

class MnemonicSuccess extends MnemonicState {
  const MnemonicSuccess({required String mnemonic}) : super(mnemonic: mnemonic);
}

class MnemonicFailure extends MnemonicState {}

class MnemonicStoreSuccess extends MnemonicState {
  const MnemonicStoreSuccess({required String mnemonic})
      : super(mnemonic: mnemonic);
}

class MnemonicStoreFailure extends MnemonicState {
  const MnemonicStoreFailure({required String mnemonic})
      : super(mnemonic: mnemonic);
}
