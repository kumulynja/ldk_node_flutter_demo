import 'package:formz/formz.dart';

enum AmountSatsError {
  empty,
  tooHigh,
}

class AmountSats extends FormzInput<int, AmountSatsError> {
  const AmountSats.pure([super.value = 0]) : super.pure();
  const AmountSats.dirty([super.value = 0]) : super.dirty();

  @override
  AmountSatsError? validator(int? value) {
    if (value == null) {
      return AmountSatsError.empty;
    }
    // Check if the amount exceeds the max bitcoin supply.
    if (value > 2100000000000000) {
      return AmountSatsError.tooHigh;
    }

    // If everything is ok, return null.
    return null;
  }
}
