import 'package:equatable/equatable.dart';

abstract class ChannelOpeningEvent extends Equatable {
  const ChannelOpeningEvent();

  @override
  List<Object?> get props => [];
}

final class AddressIpChanged extends ChannelOpeningEvent {
  const AddressIpChanged(
    this.addressIp,
  );

  final String addressIp;

  @override
  List<Object?> get props => [addressIp];
}

final class AddressIpUnfocused extends ChannelOpeningEvent {}

final class AddressPortChanged extends ChannelOpeningEvent {
  const AddressPortChanged(
    this.addressPort,
  );

  final int addressPort;

  @override
  List<Object?> get props => [addressPort];
}

final class AddressPortUnfocused extends ChannelOpeningEvent {}

final class CounterpartyPublicKeyChanged extends ChannelOpeningEvent {
  const CounterpartyPublicKeyChanged(
    this.counterpartyPublicKey,
  );

  final String counterpartyPublicKey;

  @override
  List<Object?> get props => [counterpartyPublicKey];
}

final class CounterpartyPublicKeyUnfocused extends ChannelOpeningEvent {}

final class ChannelAmountSatsChanged extends ChannelOpeningEvent {
  const ChannelAmountSatsChanged(
    this.channelAmountSats,
  );

  final int channelAmountSats;

  @override
  List<Object?> get props => [channelAmountSats];
}

final class ChannelAmountSatsUnfocused extends ChannelOpeningEvent {}

final class PushToCounterpartyMsatChanged extends ChannelOpeningEvent {
  const PushToCounterpartyMsatChanged(
    this.pushToCounterpartyMsat,
  );

  final int pushToCounterpartyMsat;

  @override
  List<Object?> get props => [pushToCounterpartyMsat];
}

final class PushToCounterpartyMsatUnfocused extends ChannelOpeningEvent {}

final class AnnounceChannelChanged extends ChannelOpeningEvent {
  const AnnounceChannelChanged(
    this.announceChannel,
  );

  final bool announceChannel;

  @override
  List<Object?> get props => [announceChannel];
}

final class ChannelOpeningSubmitted extends ChannelOpeningEvent {}
