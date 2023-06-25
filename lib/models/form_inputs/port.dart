import 'package:formz/formz.dart';

enum PortError {
  invalid,
}

class Port extends FormzInput<int, PortError> {
  const Port.pure([super.value = 9735]) : super.pure();
  const Port.dirty([super.value = 9735]) : super.dirty();

  // A port should have 1 to 5 digits.
  static final _portRegex = RegExp(
    r'^[0-9]{1,5}$',
  );

  @override
  PortError? validator(int? value) {
    return _portRegex.hasMatch(value.toString()) ? null : PortError.invalid;
  }
}
