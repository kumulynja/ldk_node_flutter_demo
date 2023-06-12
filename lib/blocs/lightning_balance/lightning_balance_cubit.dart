import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class BalanceCubit extends Cubit<int> {
  BalanceCubit({
    required LightningNodeRepository lightningNodeRepository,
  })  : _lightningNodeRepository = lightningNodeRepository,
        super(0) {
    getBalance();
    _paymentEventSubscription = _lightningNodeRepository.paymentStream.listen(
      (_) async => await getBalance(),
    );
    _channelEventSubscription = _lightningNodeRepository.channelStream.listen(
      (_) async => await getBalance(),
    );
  }

  final LightningNodeRepository _lightningNodeRepository;
  late StreamSubscription<PaymentEvent> _paymentEventSubscription;
  late StreamSubscription<ChannelEvent> _channelEventSubscription;

  Future<void> getBalance() async {
    try {
      final balance = await _lightningNodeRepository.balance;
      emit(balance.totalOutboundCapacity);
    } catch (e) {
      print("getBalance failed with error: $e");
    }
  }

  @override
  Future<void> close() {
    _paymentEventSubscription.cancel();
    _channelEventSubscription.cancel();
    return super.close();
  }
}
