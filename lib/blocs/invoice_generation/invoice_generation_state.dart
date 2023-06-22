import 'package:equatable/equatable.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/invoice_description.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/invoice_expiry_secs.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

final class InvoiceGenerationState extends Equatable {
  const InvoiceGenerationState({
    this.amountMsat = const AmountMsat.pure(),
    this.description = const InvoiceDescription.pure(),
    this.expirySecs = const InvoiceExpirySecs.pure(),
    this.isValid = false,
    this.invoice,
  });

  final AmountMsat amountMsat;
  final InvoiceDescription description;
  final InvoiceExpirySecs expirySecs;
  final bool isValid;
  final Invoice? invoice;

  InvoiceGenerationState copyWith({
    AmountMsat? amountMsat,
    InvoiceDescription? description,
    InvoiceExpirySecs? expirySecs,
    bool? isValid,
    Invoice? invoice,
  }) {
    return InvoiceGenerationState(
      amountMsat: amountMsat ?? this.amountMsat,
      description: description ?? this.description,
      expirySecs: expirySecs ?? this.expirySecs,
      isValid: isValid ?? this.isValid,
      invoice: invoice ?? this.invoice,
    );
  }

  @override
  List<Object?> get props =>
      [amountMsat, description, expirySecs, isValid, invoice];
}
