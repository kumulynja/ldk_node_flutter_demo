import 'package:equatable/equatable.dart';

abstract class RecoveryState extends Equatable {
  const RecoveryState({this.mnemonic});
  final String? mnemonic;

  @override
  List<Object?> get props => [mnemonic];
}

class RecoveryInitial extends RecoveryState {}

class RecoverySuccess extends RecoveryState {
  const RecoverySuccess({required String mnemonic}) : super(mnemonic: mnemonic);
}

class RecoveryFailure extends RecoveryState {}

class RecoveryStoreSuccess extends RecoveryState {}

class RecoveryStoreFailure extends RecoveryState {}
