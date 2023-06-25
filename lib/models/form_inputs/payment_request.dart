import 'package:formz/formz.dart';
import 'package:bech32/bech32.dart';

enum PaymentRequestError { isInvalid, isEmpty }

/// A class that represents a payment request form input.
/// A payment request can be either a BIP21 or BOLT11 invoice for this app's purposes.
/// Other types of payment requests exist though. For example Lightning Addresses and Bolt12.
/// We do not support those in this app, but you can find more information about them here:
/// todo: add link to lightning address and bolt12 specs (or create an intermezzo about them)
final class PaymentRequest extends FormzInput<String, PaymentRequestError> {
  const PaymentRequest.pure([super.value = '']) : super.pure();
  const PaymentRequest.dirty([super.value = '']) : super.dirty();

  bool get isBip21 {
    return value.contains('lightning:') || value.contains('lightning=');
  }

  String parseBip21() {
    if (value.contains('lightning=')) {
      return value.split('lightning=')[1].split('&')[0];
    }
    return value.split('lightning:')[1];
  }

  @override
  PaymentRequestError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PaymentRequestError.isEmpty;
    }

    final parsedPaymentRequest = isBip21 ? parseBip21() : value;
    try {
      final decoded = Bech32Decoder()
          .convert(parsedPaymentRequest, parsedPaymentRequest.length);
      if (!decoded.hrp.startsWith('ln')) {
        return PaymentRequestError.isInvalid;
      }
    } catch (e) {
      return PaymentRequestError.isInvalid;
    }

    return null;
  }
}
