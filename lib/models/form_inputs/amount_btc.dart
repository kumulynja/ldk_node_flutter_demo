import 'package:formz/formz.dart';

enum AmountBtcError {
  empty,
  tooHigh,
  tooManyDecimals,
}

class AmountBtc extends FormzInput<double, AmountBtcError> {
  const AmountBtc.pure([super.value = 0]) : super.pure();
  const AmountBtc.dirty([super.value = 0]) : super.dirty();

  @override
  AmountBtcError? validator(double value) {
    // Check if the amount exceeds the max bitcoin supply.
    if (value > 21000000) {
      return AmountBtcError.tooHigh;
    }

    // Check if the amount has more than 8 decimals.
    if (value.toString().split('.').last.length > 8) {
      return AmountBtcError.tooManyDecimals;
    }

    // If the amount is valid, return null.
    return null;
  }
}
