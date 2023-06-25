import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_event.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_state.dart';
import 'package:ldk_node_flutter_demo/models/decoded_invoice.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/payment_request.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class InvoicePaymentBloc
    extends Bloc<InvoicePaymentEvent, InvoicePaymentState> {
  InvoicePaymentBloc({
    required LightningNodeRepository lightningNodeRepository,
  })  : _lightningNodeRepository = lightningNodeRepository,
        super(const InvoicePaymentState()) {
    on<PaymentRequestChanged>(_onPaymentRequestChanged);
    on<PaymentRequestUnfocused>(_onPaymentRequestUnfocused);
    on<AmountMsatChanged>(_onAmountMsatChanged);
    on<AmountMsatUnfocused>(_onAmountMsatUnfocused);
    on<InvoicePaymentConfirmed>(_onInvoicePaymentConfirmed);
  }

  final LightningNodeRepository _lightningNodeRepository;

  Future<void> _onPaymentRequestChanged(
    PaymentRequestChanged event,
    Emitter<InvoicePaymentState> emit,
  ) async {
    print('_onPaymentRequestChanged START: ${state.amountMsat.value}');
    final paymentRequest = PaymentRequest.dirty(event.paymentRequest);
    emit(state.copyWith(
      paymentRequest: paymentRequest.isValid
          ? paymentRequest
          : PaymentRequest.pure(event.paymentRequest),
      isValid: Formz.validate([
        paymentRequest,
        state.amountMsat,
      ]),
    ));
    print('_onPaymentRequestChanged STOP: ${state.amountMsat.value}');
  }

  Future<void> _onPaymentRequestUnfocused(
    PaymentRequestUnfocused event,
    Emitter<InvoicePaymentState> emit,
  ) async {
    print('_onPaymentRequestUnfocused START1: ${state.amountMsat.value}');
    final paymentRequest = PaymentRequest.dirty(state.paymentRequest.value);
    emit(state.copyWith(
      paymentRequest: paymentRequest,
      isValid: Formz.validate([
        paymentRequest,
        state.amountMsat,
      ]),
    ));
    if (paymentRequest.isValid) {
      print('Payment request is valid');
      final invoice = paymentRequest.isBip21
          ? paymentRequest.parseBip21()
          : paymentRequest.value;
      print(invoice);
      // Todo: decode invoice and emit state with amount, description and a bool that says if the invoice is expired or not (if it is expired, the user should not be able to pay it)
      // On the screen also the spendable balance can be checked and if it is lower than the invoice amount, the submit button can be disabled and a message can be shown to top up its balance.
      final decodedInvoice = DecodedInvoice(invoice);
      final amountMsat = decodedInvoice.amountMsat != null
          ? AmountMsat.dirty(decodedInvoice.amountMsat!)
          : const AmountMsat.pure();
      emit(state.copyWith(
        invoice: invoice,
        amountMsat: amountMsat,
        // description: description,
        isValid: Formz.validate([
          state.paymentRequest,
          amountMsat,
        ]),
        isAmountMsatFromInvoice: decodedInvoice.amountMsat != null,
        // expirySecs: expirySecs,
        // isExpired: isExpired,
      ));
    } else {
      emit(
        state.copyWith(
          invoice: null,
          isAmountMsatFromInvoice: false,
          // description: null,
          // expirySecs: null,
          // isExpired: null,
        ),
      );
    }
    print('_onPaymentRequestUnfocused STOP: ${state.amountMsat.value}');
  }

  Future<void> _onAmountMsatChanged(
    AmountMsatChanged event,
    Emitter<InvoicePaymentState> emit,
  ) async {
    print('_onAmountMsatChanged START1: ${state.amountMsat.value}');
    final amountMsat = AmountMsat.dirty(int.parse(event.amountMsat));
    print('_onAmountMsatChanged START2: ${amountMsat.value}');
    emit(state.copyWith(
      amountMsat: amountMsat.isValid
          ? amountMsat
          : AmountMsat.pure(int.parse(event.amountMsat)),
      isValid: Formz.validate([
        state.paymentRequest,
        amountMsat,
      ]),
    ));
    print('_onAmountMsatChanged STOP: ${state.amountMsat.value}');
  }

  Future<void> _onAmountMsatUnfocused(
    AmountMsatUnfocused event,
    Emitter<InvoicePaymentState> emit,
  ) async {
    final amountMsat = AmountMsat.dirty(state.amountMsat.value);
    print('_onAmountMsatUnfocused START: ${amountMsat.value}');
    emit(state.copyWith(
      amountMsat: amountMsat,
      isValid: Formz.validate([
        state.paymentRequest,
        amountMsat,
      ]),
    ));
    print('_onAmountMsatUnfocused STOP: ${state.amountMsat.value}');
  }

  Future<void> _onInvoicePaymentConfirmed(
      InvoicePaymentEvent event, Emitter<InvoicePaymentState> emit) async {
    final paymentRequest = PaymentRequest.dirty(state.paymentRequest.value);
    final amountMsat = AmountMsat.dirty(state.amountMsat.value);
    emit(state.copyWith(
      paymentRequest: paymentRequest,
      amountMsat: amountMsat,
      isValid: Formz.validate([paymentRequest, amountMsat]),
    ));
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        U8Array32 paymentHash;
        if (state.isAmountMsatFromInvoice) {
          paymentHash = (await _lightningNodeRepository.sendInvoicePayment(
            invoice: state.invoice,
          ))
              .field0;
        } else {
          paymentHash =
              (await _lightningNodeRepository.sendInvoicePaymentUsingAmount(
            invoice: state.invoice,
            amountMsat: state.amountMsat.value,
          ))
                  .field0;
        }
        if (kDebugMode) print('paymentHash: $paymentHash');
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
