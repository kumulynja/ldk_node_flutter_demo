import 'package:equatable/equatable.dart';

abstract class WalletRecoveryEvent extends Equatable {
  const WalletRecoveryEvent();

  @override
  List<Object?> get props => [];
}

final class MnemonicChanged extends WalletRecoveryEvent {
  const MnemonicChanged(
    this.mnemonic,
  );

  final String mnemonic;

  @override
  List<Object?> get props => [mnemonic];
}

final class MnemonicUnfocused extends WalletRecoveryEvent {}
