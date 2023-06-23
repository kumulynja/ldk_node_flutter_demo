import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_event.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_payment/invoice_payment_state.dart';
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
  }

  final LightningNodeRepository _lightningNodeRepository;

  Future<void> _onPaymentRequestChanged(
    PaymentRequestChanged event,
    Emitter<InvoicePaymentState> emit,
  ) async {
    final paymentRequest = PaymentRequest.dirty(event.paymentRequest);
    emit(state.copyWith(
      paymentRequest: paymentRequest.isValid
          ? paymentRequest
          : PaymentRequest.pure(event.paymentRequest),
      isValid: Formz.validate([paymentRequest]),
    ));
  }

  Future<void> _onPaymentRequestUnfocused(
    PaymentRequestUnfocused event,
    Emitter<InvoicePaymentState> emit,
  ) async {
    final paymentRequest = PaymentRequest.dirty(state.paymentRequest.value);
    emit(state.copyWith(
      paymentRequest: paymentRequest,
      isValid: Formz.validate([paymentRequest]),
    ));
    if (state.isValid) {
      final invoice = paymentRequest.isBip21
          ? paymentRequest.parseBip21()
          : paymentRequest.value;
      // Todo: decode invoice and emit state with amount, description and a bool that says if the invoice is expired or not (if it is expired, the user should not be able to pay it)
      // On the screen also the spendable balance can be checked and if it is lower than the invoice amount, the submit button can be disabled and a message can be shown to top up its balance.
      emit(state.copyWith(
        invoice: invoice,
        //amount: amount,
        //description: description,
        //expirySecs: expirySecs,
        //isExpired: isExpired,
      ));
    }
  }
}
