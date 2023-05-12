import 'package:equatable/equatable.dart';

class Node extends Equatable {
  const Node(this.id, this.alias);

  final String id;
  final String alias;

  @override
  List<Object> get props => [id, alias];
}
