import 'package:ldk_node/ldk_node.dart';

extension U8Array32X on U8Array32 {
  String get asHex =>
      this.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}
