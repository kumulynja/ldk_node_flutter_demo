import 'package:equatable/equatable.dart';

abstract class InvoicePaymentEvent extends Equatable {
  const InvoicePaymentEvent();

  @override
  List<Object?> get props => [];
}

final class InvoicePaymentStarted extends InvoicePaymentEvent {}

final class PaymentRequestChanged extends InvoicePaymentEvent {
  const PaymentRequestChanged(
    this.paymentRequest,
  );

  final String paymentRequest;

  @override
  List<Object?> get props => [paymentRequest];
}

final class PaymentRequestUnfocused extends InvoicePaymentEvent {}

final class InvoicePaymentSubmitted extends InvoicePaymentEvent {}
