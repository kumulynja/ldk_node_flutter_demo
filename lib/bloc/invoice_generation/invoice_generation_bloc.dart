import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_generation/invoice_generation_event.dart';
import 'package:ldk_node_flutter_demo/bloc/invoice_generation/invoice_generation_state.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/invoice_description.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/invoice_expiry_secs.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class InvoiceGenerationBloc
    extends Bloc<InvoiceGenerationEvent, InvoiceGenerationState> {
  InvoiceGenerationBloc({
    required LightningNodeRepository lightningNodeRepository,
  })  : _lightningNodeRepository = lightningNodeRepository,
        super(const InvoiceGenerationState()) {
    on<InvoiceGenerationStarted>(_onInvoiceGenerationStarted);
    on<AmountMsatChanged>(_onAmountMsatChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<ExpirySecsChanged>(_onExpirySecsChanged);
    on<AmountMsatUnfocused>(_onAmountMsatUnfocused);
    on<DescriptionUnfocused>(_onDescriptionUnfocused);
    on<ExpirySecsUnfocused>(_onExpirySecsUnfocused);
  }

  final LightningNodeRepository _lightningNodeRepository;

  Future<void> _onInvoiceGenerationStarted(InvoiceGenerationStarted event,
      Emitter<InvoiceGenerationState> emit) async {
    final invoice =
        await _lightningNodeRepository.generateInvoiceWithoutAmount();
    emit(state.copyWith(
      invoice: invoice,
    ));
  }

  void _onAmountMsatChanged(
      AmountMsatChanged event, Emitter<InvoiceGenerationState> emit) {
    final amountMsat = AmountMsat.dirty(event.amountMsat);
    emit(state.copyWith(
      amountMsat:
          amountMsat.isValid ? amountMsat : AmountMsat.pure(event.amountMsat),
      isValid:
          Formz.validate([amountMsat, state.description, state.expirySecs]),
    ));
  }

  Future<void> _onAmountMsatUnfocused(
      AmountMsatUnfocused event, Emitter<InvoiceGenerationState> emit) async {
    final amountMsat = AmountMsat.dirty(state.amountMsat.value);
    emit(state.copyWith(
      amountMsat: amountMsat,
      isValid:
          Formz.validate([amountMsat, state.description, state.expirySecs]),
    ));
    if (state.isValid) {
      final invoice = amountMsat.value > 0
          ? await _lightningNodeRepository.generateInvoiceWithAmount(
              amountMsat: amountMsat.value,
              description: state.description.value,
              expirySecs: state.expirySecs.value,
            )
          : await _lightningNodeRepository.generateInvoiceWithoutAmount(
              description: state.description.value,
              expirySecs: state.expirySecs.value,
            );
      emit(state.copyWith(
        invoice: invoice,
      ));
    }
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<InvoiceGenerationState> emit) {
    final description = InvoiceDescription.dirty(event.description);
    emit(state.copyWith(
      description: description.isValid
          ? description
          : InvoiceDescription.pure(event.description),
      isValid:
          Formz.validate([state.amountMsat, description, state.expirySecs]),
    ));
  }

  Future<void> _onDescriptionUnfocused(
      DescriptionUnfocused event, Emitter<InvoiceGenerationState> emit) async {
    final description = InvoiceDescription.dirty(state.description.value);
    emit(state.copyWith(
      description: description,
      isValid:
          Formz.validate([state.amountMsat, description, state.expirySecs]),
    ));
    if (state.isValid) {
      final invoice = state.amountMsat.value > 0
          ? await _lightningNodeRepository.generateInvoiceWithAmount(
              amountMsat: state.amountMsat.value,
              description: description.value,
              expirySecs: state.expirySecs.value,
            )
          : await _lightningNodeRepository.generateInvoiceWithoutAmount(
              description: description.value,
              expirySecs: state.expirySecs.value,
            );
      emit(state.copyWith(
        invoice: invoice,
      ));
    }
  }

  void _onExpirySecsChanged(
      ExpirySecsChanged event, Emitter<InvoiceGenerationState> emit) {
    final expirySecs = InvoiceExpirySecs.dirty(event.expirySecs);
    emit(state.copyWith(
      expirySecs: expirySecs.isValid
          ? expirySecs
          : InvoiceExpirySecs.pure(event.expirySecs),
      isValid:
          Formz.validate([state.amountMsat, state.description, expirySecs]),
    ));
  }

  Future<void> _onExpirySecsUnfocused(
      ExpirySecsUnfocused event, Emitter<InvoiceGenerationState> emit) async {
    final expirySecs = InvoiceExpirySecs.dirty(state.expirySecs.value);
    emit(state.copyWith(
      expirySecs: expirySecs,
      isValid:
          Formz.validate([state.amountMsat, state.description, expirySecs]),
    ));
    if (state.isValid) {
      final invoice = state.amountMsat.value > 0
          ? await _lightningNodeRepository.generateInvoiceWithAmount(
              amountMsat: state.amountMsat.value,
              description: state.description.value,
              expirySecs: expirySecs.value,
            )
          : await _lightningNodeRepository.generateInvoiceWithoutAmount(
              description: state.description.value,
              expirySecs: expirySecs.value,
            );
      emit(state.copyWith(
        invoice: invoice,
      ));
    }
  }
}
