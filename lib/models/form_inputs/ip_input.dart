import 'package:formz/formz.dart';

enum IpInputError {
  invalid,
}

class IpInput extends FormzInput<String, IpInputError> {
  const IpInput.pure([super.value = '']) : super.pure();
  const IpInput.dirty([super.value = '']) : super.dirty();

  static final _ipRegex = RegExp(
    r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}$',
  );

  @override
  IpInputError? validator(String? value) {
    return _ipRegex.hasMatch(value ?? '') ? null : IpInputError.invalid;
  }
}
