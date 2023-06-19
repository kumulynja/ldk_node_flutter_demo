import 'package:formz/formz.dart';

enum IpError {
  invalid,
}

class Ip extends FormzInput<String, IpError> {
  const Ip.pure([super.value = '']) : super.pure();
  const Ip.dirty([super.value = '']) : super.dirty();

  static final _ipRegex = RegExp(
    r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}$',
  );

  @override
  IpError? validator(String? value) {
    return _ipRegex.hasMatch(value ?? '') ? null : IpError.invalid;
  }
}
