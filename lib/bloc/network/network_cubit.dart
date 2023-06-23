import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/enums/app_network.dart';

class NetworkCubit extends Cubit<AppNetwork> {
  // Default network is Regtest, at the moment of creating the NetworkCubit, another network can be set
  NetworkCubit([AppNetwork network = AppNetwork.regtest]) : super(network);

  void setNetwork(AppNetwork network) {
    emit(network);
  }
}
