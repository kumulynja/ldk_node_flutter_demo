import 'package:equatable/equatable.dart';

abstract class MnemonicGenerationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MnemonicGenerationStarted extends MnemonicGenerationEvent {}

class MnemonicGenerationRetried extends MnemonicGenerationEvent {}

class MnemonicConfirmed extends MnemonicGenerationEvent {}
