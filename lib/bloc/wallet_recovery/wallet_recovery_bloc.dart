import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/wallet_recovery/wallet_recovery_event.dart';
import 'package:ldk_node_flutter_demo/bloc/wallet_recovery/wallet_recovery_state.dart';

class WalletRecoveryBloc
    extends Bloc<WalletRecoveryEvent, WalletRecoveryState> {
  WalletRecoveryBloc() : super(const WalletRecoveryState());
}
