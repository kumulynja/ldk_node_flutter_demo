import 'package:equatable/equatable.dart';

abstract class MnemonicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MnemonicGenerationPressed extends MnemonicEvent {}

class MnemonicConfirmed extends MnemonicEvent {}
