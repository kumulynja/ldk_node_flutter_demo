import 'package:equatable/equatable.dart';

abstract class InvoiceGenerationEvent extends Equatable {
  const InvoiceGenerationEvent();

  @override
  List<Object?> get props => [];
}

final class InvoiceGenerationStarted extends InvoiceGenerationEvent {}

final class AmountMsatChanged extends InvoiceGenerationEvent {
  const AmountMsatChanged(
    this.amountMsat,
  );

  final int amountMsat;

  @override
  List<Object?> get props => [amountMsat];
}

final class AmountMsatUnfocused extends InvoiceGenerationEvent {}

final class DescriptionChanged extends InvoiceGenerationEvent {
  const DescriptionChanged(
    this.description,
  );

  final String description;

  @override
  List<Object?> get props => [description];
}

final class DescriptionUnfocused extends InvoiceGenerationEvent {}

final class ExpirySecsChanged extends InvoiceGenerationEvent {
  const ExpirySecsChanged(
    this.expirySecs,
  );

  final int expirySecs;

  @override
  List<Object?> get props => [expirySecs];
}

final class ExpirySecsUnfocused extends InvoiceGenerationEvent {}
