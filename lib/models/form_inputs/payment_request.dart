import 'package:formz/formz.dart';
import 'package:bech32/bech32.dart';

enum PaymentRequestError { isInvalid, isEmpty }

final class PaymentRequest extends FormzInput<String, PaymentRequestError> {
  const PaymentRequest.pure([super.value = '']) : super.pure();
  const PaymentRequest.dirty([super.value = '']) : super.dirty();

  bool get isBip21 {
    return value.contains('lightning:');
  }

  String parseBip21() {
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
      if (decoded.hrp != 'lnbc') {
        return PaymentRequestError.isInvalid;
      }
    } catch (e) {
      return PaymentRequestError.isInvalid;
    }

    return null;
  }
}
