import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_state.dart';
import 'package:ldk_node_flutter_demo/enums/app_network_extension.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:seed_repository/seed_repository.dart';

class LightningNodeBloc extends Bloc<LightningNodeEvent, LightningNodeState> {
  LightningNodeBloc(
      {required LightningNodeRepository lightningNodeRepository,
      required SeedRepository seedRepository})
      : _lightningNodeRepository = lightningNodeRepository,
        _seedRepository = seedRepository,
        super(const LightningNodeInitial()) {
    on<LightningNodeStarted>(_onLightningNodeStarted);
    on<LightningNodeRefreshed>(_onLightningNodeRefreshed);
    on<ChannelEventReceived>(_onChannelEventReceived);
    on<PaymentEventReceived>(_onPaymentEventReceived);
    // Subscribe to the streams
    _channelEventSubscription = _lightningNodeRepository.channelStream.listen(
      (channelEvent) {
        add(ChannelEventReceived(channelEvent));
      },
    );
    _paymentEventSubscription = _lightningNodeRepository.paymentStream.listen(
      (paymentEvent) {
        add(PaymentEventReceived(paymentEvent));
      },
    );
  }

  final LightningNodeRepository _lightningNodeRepository;
  final SeedRepository _seedRepository;
  late StreamSubscription<ChannelEvent> _channelEventSubscription;
  late StreamSubscription<PaymentEvent> _paymentEventSubscription;

  @override
  Future<void> close() async {
    await _paymentEventSubscription.cancel();
    await _channelEventSubscription.cancel();
    await _lightningNodeRepository.stopNode();
    return super.close();
  }

  FutureOr<void> _onLightningNodeStarted(
    LightningNodeStarted event,
    Emitter<LightningNodeState> emit,
  ) async {
    try {
      final mnemonic = await _seedRepository.retrieveMnemonic();
      //final seed = await mnemonic.toLightningSeed(event.network.asSeedRepositoryNetwork, event.password);
      //print("seed: $seed");
      await _lightningNodeRepository.startNodeWithMnemonic(
          mnemonic: mnemonic.asString(),
          network: event.network.asLightningNodeRepositoryNetwork);
      final nodeId = await _lightningNodeRepository.nodeId;
      print('nodeId in _onLightningNodeStarted: $nodeId');
      final balance = await _lightningNodeRepository.balance;
      print(
          'balance in _onLightningNodeStarted: ${balance.totalOutboundCapacity}');
      emit(
        LightningNodeRunSuccess(
          network: event.network,
          nodeId: nodeId,
          balance: balance.totalOutboundCapacity,
        ),
      );
    } catch (e) {
      print("node start failed with error: $e");
      emit(const LightningNodeRunFailure());
    }
  }

  Future<void> _onLightningNodeRefreshed(
    LightningNodeRefreshed event,
    Emitter<LightningNodeState> emit,
  ) async {
    print('_onLightningNodeRefreshed');
    if (state is LightningNodeRunSuccess) {
      final balance = await _lightningNodeRepository.balance;
      print(
        'balance in _onLightningNodeRefreshed: ${balance.totalOutboundCapacity}',
      );
      emit((state as LightningNodeRunSuccess).copyWith(
        balance: balance.totalOutboundCapacity,
      ));
    }
  }

  Future<void> _onPaymentEventReceived(
    PaymentEventReceived event,
    Emitter<LightningNodeState> emit,
  ) async {
    print('payment event received: $event');
    final balance = await _lightningNodeRepository.balance;
    if (state is LightningNodeRunSuccess) {
      emit((state as LightningNodeRunSuccess)
          .copyWith(balance: balance.totalOutboundCapacity));
    }
  }

  Future<void> _onChannelEventReceived(
    ChannelEventReceived event,
    Emitter<LightningNodeState> emit,
  ) async {
    print("channel event received: $event");
    final balance = await _lightningNodeRepository.balance;
    if (state is LightningNodeRunSuccess) {
      emit((state as LightningNodeRunSuccess)
          .copyWith(balance: balance.totalOutboundCapacity));
    }
  }
}
