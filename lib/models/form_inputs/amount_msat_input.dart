import 'package:formz/formz.dart';

enum AmountMsatInputError {
  empty,
  tooHigh,
}

class AmountMsatInput extends FormzInput<int, AmountMsatInputError> {
  const AmountMsatInput.pure([super.value = 0]) : super.pure();
  const AmountMsatInput.dirty([super.value = 0]) : super.dirty();

  @override
  AmountMsatInputError? validator(int? value) {
    if (value == null) {
      return AmountMsatInputError.empty;
    }

    // Check if the amount exceeds the max bitcoin supply.
    if (value > 2100000000000000000) {
      return AmountMsatInputError.tooHigh;
    }

    // If everything is ok, return null.
    return null;
  }
}
