import 'package:lightning_node_repository/lightning_node_repository.dart';

abstract class LightningChannelsState {}

class LightningChannelsInitial extends LightningChannelsState {}

class LightningChannelsLoadInProgress extends LightningChannelsState {}

class LightningChannelsLoadSuccess extends LightningChannelsState {
  final List<Channel> readyChannels;
  final List<Channel> pendingChannels;
  final List<Channel> closedChannels;

  LightningChannelsLoadSuccess({
    required this.readyChannels,
    required this.pendingChannels,
    required this.closedChannels,
  });
}

class LightningChannelsLoadFailure extends LightningChannelsState {}
