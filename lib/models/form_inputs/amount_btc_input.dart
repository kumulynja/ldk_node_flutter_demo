import 'package:formz/formz.dart';

enum AmountBtcInputError {
  empty,
  tooHigh,
  tooManyDecimals,
}

class AmountBtcInout extends FormzInput<double, AmountBtcInputError> {
  const AmountBtcInout.pure() : super.pure(0);
  const AmountBtcInout.dirty([double value = 0]) : super.dirty(value);

  @override
  AmountBtcInputError? validator(double? value) {
    if (value == null) {
      return AmountBtcInputError.empty;
    }

    // Check if the amount exceeds the max bitcoin supply.
    if (value > 21000000) {
      return AmountBtcInputError.tooHigh;
    }

    // Check if the amount has more than 8 decimals.
    if (value.toString().split('.').last.length > 8) {
      return AmountBtcInputError.tooManyDecimals;
    }

    // If the amount is valid, return null.
    return null;
  }
}
