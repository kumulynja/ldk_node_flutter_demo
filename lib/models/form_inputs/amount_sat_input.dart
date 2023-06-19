import 'package:formz/formz.dart';

enum AmountSatInputError {
  empty,
  tooHigh,
}

class AmountSatInput extends FormzInput<int, AmountSatInputError> {
  const AmountSatInput.pure([super.value = 0]) : super.pure();
  const AmountSatInput.dirty([super.value = 0]) : super.dirty();

  @override
  AmountSatInputError? validator(int? value) {
    if (value == null) {
      return AmountSatInputError.empty;
    }
    // Check if the amount exceeds the max bitcoin supply.
    if (value > 2100000000000000) {
      return AmountSatInputError.tooHigh;
    }

    // If everything is ok, return null.
    return null;
  }
}
