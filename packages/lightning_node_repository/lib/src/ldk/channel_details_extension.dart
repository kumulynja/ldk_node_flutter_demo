import 'package:ldk_node/ldk_node.dart';
import 'package:lightning_node_repository/src/models/channel.dart';

extension ChannelDetailsX on ChannelDetails {
  Channel get asChannel => Channel(
        channelId: channelId,
        outboundCapacityMsat: outboundCapacityMsat,
        inboundCapacityMsat: inboundCapacityMsat,
      );
}
