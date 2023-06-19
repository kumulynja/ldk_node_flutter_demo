import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_msat.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/amount_sats.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/ip.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/node_id.dart';
import 'package:ldk_node_flutter_demo/models/form_inputs/port.dart';

final class ChannelOpeningState extends Equatable {
  const ChannelOpeningState({
    this.addressIp = const Ip.pure(),
    this.addressPort = const Port.pure(),
    this.counterpartyPublicKey = const NodeId.pure(),
    this.channelAmountSats = const AmountSats.pure(),
    this.pushToCounterpartyMsat = const AmountMsat.pure(),
    this.announceChannel = false,
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  });

  final Ip addressIp;
  final Port addressPort;
  final NodeId counterpartyPublicKey;
  final AmountSats channelAmountSats;
  final AmountMsat pushToCounterpartyMsat;
  final bool announceChannel;
  final bool isValid;
  final FormzSubmissionStatus status;

  ChannelOpeningState copyWith({
    Ip? addressIp,
    Port? addressPort,
    NodeId? counterpartyPublicKey,
    AmountSats? channelAmountSats,
    AmountMsat? pushToCounterpartyMsat,
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
