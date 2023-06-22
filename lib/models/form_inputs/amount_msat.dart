import 'package:formz/formz.dart';

enum AmountMsatError {
  tooHigh,
}

class AmountMsat extends FormzInput<int, AmountMsatError> {
  const AmountMsat.pure([super.value = 0]) : super.pure();
  const AmountMsat.dirty([super.value = 0]) : super.dirty();

  @override
  AmountMsatError? validator(int value) {
    // Check if the amount exceeds the max bitcoin supply.
    if (value > 2100000000000000000) {
      return AmountMsatError.tooHigh;
    }

    // If everything is ok, return null.
    return null;
  }
}
