import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

final class WalletRecoveryState extends Equatable {
  const WalletRecoveryState({
    this.mnemonic,
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  });
  final String? mnemonic;
  final bool isValid;
  final FormzSubmissionStatus status;

  WalletRecoveryState copyWith({
    String? mnemonic,
    bool? isValid,
    FormzSubmissionStatus? status,
  }) {
    return WalletRecoveryState(
      mnemonic: mnemonic ?? this.mnemonic,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [mnemonic, isValid, status];
}
