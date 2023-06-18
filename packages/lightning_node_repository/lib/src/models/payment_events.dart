import 'package:ldk_node/ldk_node.dart';

abstract class PaymentEvent {
  final U8Array32 paymentHash;

  PaymentEvent(this.paymentHash);
}

class PaymentSuccessful extends PaymentEvent {
  PaymentSuccessful(U8Array32 paymentHash) : super(paymentHash);
}

class PaymentFailed extends PaymentEvent {
  PaymentFailed(U8Array32 paymentHash) : super(paymentHash);
}

class PaymentReceived extends PaymentEvent {
  final int amountMsat;

  PaymentReceived(U8Array32 paymentHash, this.amountMsat) : super(paymentHash);
}
