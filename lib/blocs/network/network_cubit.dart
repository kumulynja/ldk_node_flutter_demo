import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class NetworkCubit extends Cubit<Network> {
  // Default network is Regtest, at the moment of creating the NetworkCubit, another network can be set
  NetworkCubit([Network network = Network.Regtest]) : super(network);

  void setNetwork(Network network) {
    emit(network);
  }
}
