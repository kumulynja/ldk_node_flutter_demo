import 'package:formz/formz.dart';

enum NodeIdError {
  invalid,
}

class NodeId extends FormzInput<String, NodeIdError> {
  const NodeId.pure([super.value = '']) : super.pure();
  const NodeId.dirty([super.value = '']) : super.dirty();

  //static final _nodeIdRegex = RegExp(
  //  r'^[0-9a-fA-F]{64}$',
  //);

  @override
  NodeIdError? validator(String? value) {
    return null;
    //return _nodeIdRegex.hasMatch(value ?? '') ? null : NodeIdError.invalid;
  }
}
