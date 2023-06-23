import 'package:equatable/equatable.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/payment_request.dart';

final class InvoicePaymentState extends Equatable {
  const InvoicePaymentState({
    this.paymentRequest = const PaymentRequest.pure(),
    this.amountMsat = const AmountMsat.pure(),
    // this.description = const InvoiceDescription.pure(),
    this.isValid = false,
    this.invoice,
    this.amount,
    this.isExpired = false,
    this.expirySecs = 0,
  });

  final PaymentRequest paymentRequest;
  final AmountMsat amountMsat;
  // final InvoiceDescription description;
  final bool isValid;
  final String? invoice;
  final int? amount;
  final bool isExpired;
  final int expirySecs;

  InvoicePaymentState copyWith({
    PaymentRequest? paymentRequest,
    AmountMsat? amountMsat,
    // InvoiceDescription? description,
    bool? isValid,
    String? invoice,
    int? amount,
    bool? isExpired,
    int? expirySecs,
  }) {
    return InvoicePaymentState(
      paymentRequest: paymentRequest ?? this.paymentRequest,
      amountMsat: amountMsat ?? this.amountMsat,
      // description: description ?? this.description,
      isValid: isValid ?? this.isValid,
      invoice: invoice ?? this.invoice,
      amount: amount ?? this.amount,
      isExpired: isExpired ?? this.isExpired,
      expirySecs: expirySecs ?? this.expirySecs,
    );
  }

  @override
  List<Object?> get props => [
        paymentRequest,
        amountMsat,
        isValid,
        invoice,
        amount,
        isExpired,
        expirySecs
      ];
}
