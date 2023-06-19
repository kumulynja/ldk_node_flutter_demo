import 'package:formz/formz.dart';

enum PortInputError {
  invalid,
}

class PortInput extends FormzInput<int, PortInputError> {
  const PortInput.pure([super.value = 9735]) : super.pure();
  const PortInput.dirty([super.value = 9735]) : super.dirty();

  // A port should have 1 to 5 digits.
  static final _portRegex = RegExp(
    r'^[0-9]{1,5}$',
  );

  @override
  PortInputError? validator(int? value) {
    return _portRegex.hasMatch(value.toString())
        ? null
        : PortInputError.invalid;
  }
}
