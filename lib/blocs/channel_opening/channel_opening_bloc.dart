import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ldk_node_flutter_demo/blocs/channel_opening/channel_opening_event.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_sat_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/ip_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/node_id_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/port_input.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

import 'channel_opening_state.dart';

/// This bloc manages the channel opening form in a way that does not show an error while the user is typing, only when he unfocusses from the input.
/// This is achieved in the following way:
/// The unfocus event is treated as an opportunity to mark the form field as "dirty" and potentially show validation error messages. The distinction between handling onChange and onUnfocused events has to do with the user experience.
/// 1. On Change (Typing): As the user is typing into the field, you may not want to immediately show error messages. For example, when a user starts typing an email, it's initially invalid until they complete it. Showing an error message too early (as they type) could be seen as aggressive or annoying. The onChange event in this case can be used to update the field's value without necessarily showing validation errors.
/// 2. On Unfocus (Field Blur): When the user moves focus away from the field, it's often a signal that they have finished entering the data in that field. At this point, it's a good practice to run validations and show any error messages if the data is invalid. This helps the user understand if they need to correct anything before submitting the form.
/// By using this combination of onChange and onUnfocused, a more pleasant user experience is provided:
/// - The form updates as the user types without being too eager to show errors.
/// - Validation errors are displayed once the user moves on, guiding them to correct issues before submission.
class ChannelOpeningBloc
    extends Bloc<ChannelOpeningEvent, ChannelOpeningState> {
  ChannelOpeningBloc({required LightningNodeRepository lightningNodeRepository})
      : _lightningNodeRepository = lightningNodeRepository,
        super(const ChannelOpeningState()) {
    on<AddressIpChanged>(_onAddressIpChanged);
    on<AddressIpUnfocused>(_onAddressIpUnfocused);
    on<AddressPortChanged>(_onAddressPortChanged);
    on<AddressPortUnfocused>(_onAddressPortUnfocused);
    on<CounterpartyPublicKeyChanged>(_onCounterpartyPublicKeyChanged);
    on<CounterpartyPublicKeyUnfocused>(_onCounterpartyPublicKeyUnfocused);
    on<ChannelAmountSatsChanged>(_onChannelAmountSatsChanged);
    on<ChannelAmountSatsUnfocused>(_onChannelAmountSatsUnfocused);
    on<PushToCounterpartyMsatChanged>(_onPushToCounterpartyMsatChanged);
    on<PushToCounterpartyMsatUnfocused>(_onPushToCounterpartyMsatUnfocused);
    on<AnnounceChannelChanged>(_onAnnounceChannelChanged);
    on<ChannelOpeningSubmitted>(_onChannelOpeningSubmitted);
  }

  final LightningNodeRepository _lightningNodeRepository;

  void _onAddressIpChanged(
    AddressIpChanged event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final addressIp = IpInput.dirty(event.addressIp);
    emit(state.copyWith(
      addressIp: addressIp.isValid ? addressIp : IpInput.pure(event.addressIp),
      isValid: Formz.validate([
        addressIp,
        state.addressPort,
        state.counterpartyPublicKey,
        state.channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onAddressIpUnfocused(
    AddressIpUnfocused event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final addressIp = IpInput.dirty(state.addressIp.value);
    emit(state.copyWith(
      addressIp: addressIp,
      isValid: Formz.validate([
        addressIp,
        state.addressPort,
        state.counterpartyPublicKey,
        state.channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onAddressPortChanged(
    AddressPortChanged event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final addressPort = PortInput.dirty(event.addressPort);
    emit(state.copyWith(
      addressPort:
          addressPort.isValid ? addressPort : PortInput.pure(event.addressPort),
      isValid: Formz.validate([
        state.addressIp,
        addressPort,
        state.counterpartyPublicKey,
        state.channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onAddressPortUnfocused(
    AddressPortUnfocused event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final addressPort = PortInput.dirty(state.addressPort.value);
    emit(state.copyWith(
      addressPort: addressPort,
      isValid: Formz.validate([
        state.addressIp,
        addressPort,
        state.counterpartyPublicKey,
        state.channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onCounterpartyPublicKeyChanged(
    CounterpartyPublicKeyChanged event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final counterpartyPublicKey =
        NodeIdInput.dirty(event.counterpartyPublicKey);
    emit(state.copyWith(
      counterpartyPublicKey: counterpartyPublicKey.isValid
          ? counterpartyPublicKey
          : NodeIdInput.pure(event.counterpartyPublicKey),
      isValid: Formz.validate([
        state.addressIp,
        state.addressPort,
        counterpartyPublicKey,
        state.channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onCounterpartyPublicKeyUnfocused(
    CounterpartyPublicKeyUnfocused event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final counterpartyPublicKey =
        NodeIdInput.dirty(state.counterpartyPublicKey.value);
    emit(state.copyWith(
      counterpartyPublicKey: counterpartyPublicKey,
      isValid: Formz.validate([
        state.addressIp,
        state.addressPort,
        counterpartyPublicKey,
        state.channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onChannelAmountSatsChanged(
    ChannelAmountSatsChanged event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final channelAmountSats = AmountSatInput.dirty(event.channelAmountSats);
    emit(state.copyWith(
      channelAmountSats: channelAmountSats.isValid
          ? channelAmountSats
          : AmountSatInput.pure(event.channelAmountSats),
      isValid: Formz.validate([
        state.addressIp,
        state.addressPort,
        state.counterpartyPublicKey,
        channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onChannelAmountSatsUnfocused(
    ChannelAmountSatsUnfocused event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final channelAmountSats =
        AmountSatInput.dirty(state.channelAmountSats.value);
    emit(state.copyWith(
      channelAmountSats: channelAmountSats,
      isValid: Formz.validate([
        state.addressIp,
        state.addressPort,
        state.counterpartyPublicKey,
        channelAmountSats,
        state.pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onPushToCounterpartyMsatChanged(
    PushToCounterpartyMsatChanged event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final pushToCounterpartyMsat =
        AmountMsatInput.dirty(event.pushToCounterpartyMsat);
    emit(state.copyWith(
      pushToCounterpartyMsat: pushToCounterpartyMsat.isValid
          ? pushToCounterpartyMsat
          : AmountMsatInput.pure(event.pushToCounterpartyMsat),
      isValid: Formz.validate([
        state.addressIp,
        state.addressPort,
        state.counterpartyPublicKey,
        state.channelAmountSats,
        pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onPushToCounterpartyMsatUnfocused(
    PushToCounterpartyMsatUnfocused event,
    Emitter<ChannelOpeningState> emit,
  ) {
    final pushToCounterpartyMsat =
        AmountMsatInput.dirty(state.pushToCounterpartyMsat.value);
    emit(state.copyWith(
      pushToCounterpartyMsat: pushToCounterpartyMsat,
      isValid: Formz.validate([
        state.addressIp,
        state.addressPort,
        state.counterpartyPublicKey,
        state.channelAmountSats,
        pushToCounterpartyMsat,
      ]),
    ));
  }

  void _onAnnounceChannelChanged(
    AnnounceChannelChanged event,
    Emitter<ChannelOpeningState> emit,
  ) {
    emit(state.copyWith(
      announceChannel: event.announceChannel,
    ));
  }

  Future<void> _onChannelOpeningSubmitted(
    ChannelOpeningSubmitted event,
    Emitter<ChannelOpeningState> emit,
  ) async {
    try {
      final addressIp = IpInput.dirty(state.addressIp.value);
      final addressPort = PortInput.dirty(state.addressPort.value);
      final counterpartyPublicKey =
          NodeIdInput.dirty(state.counterpartyPublicKey.value);
      final channelAmountSats =
          AmountSatInput.dirty(state.channelAmountSats.value);
      final pushToCounterpartyMsat =
          AmountMsatInput.dirty(state.pushToCounterpartyMsat.value);
      final announceChannel = state.announceChannel;
      emit(
        state.copyWith(
          addressIp: addressIp,
          addressPort: addressPort,
          counterpartyPublicKey: counterpartyPublicKey,
          channelAmountSats: channelAmountSats,
          pushToCounterpartyMsat: pushToCounterpartyMsat,
          announceChannel: announceChannel,
          isValid: Formz.validate([
            addressIp,
            addressPort,
            counterpartyPublicKey,
            channelAmountSats,
            pushToCounterpartyMsat,
          ]),
        ),
      );
      if (state.isValid) {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        await _lightningNodeRepository.connectOpenChannel(
          addressIp: addressIp.value,
          addressPort: addressPort.value,
          counterpartyPublicKey: counterpartyPublicKey.value,
          channelAmountSats: channelAmountSats.value,
          pushToCounterpartyMsat: pushToCounterpartyMsat.value,
          announceChannel: announceChannel,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      }
    } catch (e) {
      if (kDebugMode) print(e);
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
