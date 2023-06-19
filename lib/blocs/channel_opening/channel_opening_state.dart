import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_sat_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/ip_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/node_id_input.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/port_input.dart';

final class ChannelOpeningState extends Equatable {
  const ChannelOpeningState({
    this.addressIp = const IpInput.pure(),
    this.addressPort = const PortInput.pure(),
    this.counterpartyPublicKey = const NodeIdInput.pure(),
    this.channelAmountSats = const AmountSatInput.pure(),
    this.pushToCounterpartyMsat = const AmountMsatInput.pure(),
    this.announceChannel = false,
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  });

  final IpInput addressIp;
  final PortInput addressPort;
  final NodeIdInput counterpartyPublicKey;
  final AmountSatInput channelAmountSats;
  final AmountMsatInput pushToCounterpartyMsat;
  final bool announceChannel;
  final bool isValid;
  final FormzSubmissionStatus status;

  ChannelOpeningState copyWith({
    IpInput? addressIp,
    PortInput? addressPort,
    NodeIdInput? counterpartyPublicKey,
    AmountSatInput? channelAmountSats,
    AmountMsatInput? pushToCounterpartyMsat,
    bool? announceChannel,
    bool? isValid,
    FormzSubmissionStatus? status,
  }) {
    return ChannelOpeningState(
      addressIp: addressIp ?? this.addressIp,
      addressPort: addressPort ?? this.addressPort,
      counterpartyPublicKey:
          counterpartyPublicKey ?? this.counterpartyPublicKey,
      channelAmountSats: channelAmountSats ?? this.channelAmountSats,
      pushToCounterpartyMsat:
          pushToCounterpartyMsat ?? this.pushToCounterpartyMsat,
      announceChannel: announceChannel ?? this.announceChannel,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        addressIp,
        addressPort,
        counterpartyPublicKey,
        channelAmountSats,
        pushToCounterpartyMsat,
        announceChannel,
        isValid,
        status
      ];
}
