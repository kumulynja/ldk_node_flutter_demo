import 'package:formz/formz.dart';

enum NodeIdInputError {
  invalid,
}

class NodeIdInput extends FormzInput<String, NodeIdInputError> {
  const NodeIdInput.pure([super.value = '']) : super.pure();
  const NodeIdInput.dirty([super.value = '']) : super.dirty();

  static final _nodeIdRegex = RegExp(
    r'^[0-9a-fA-F]{64}$',
  );

  @override
  NodeIdInputError? validator(String? value) {
    return _nodeIdRegex.hasMatch(value ?? '') ? null : NodeIdInputError.invalid;
  }
}
