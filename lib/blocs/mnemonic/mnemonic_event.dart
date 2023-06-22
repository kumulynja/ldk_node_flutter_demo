import 'package:equatable/equatable.dart';

abstract class MnemonicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MnemonicGenerationStarted extends MnemonicEvent {}

class MnemonicGenerationRetried extends MnemonicEvent {}

class MnemonicConfirmed extends MnemonicEvent {}
