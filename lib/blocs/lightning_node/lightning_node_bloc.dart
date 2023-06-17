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
  Future<void> close() {
    _paymentEventSubscription.cancel();
    _channelEventSubscription.cancel();
    _lightningNodeRepository.stopNode();
    return super.close();
  }

  Future<void> _onLightningNodeStarted(
    LightningNodeStarted event,
    Emitter<LightningNodeState> emit,
  ) async {
    try {
      final mnemonic = await _seedRepository.retrieveMnemonic();
      //final seed = await mnemonic.toLightningSeed(event.network.asSeedRepositoryNetwork, event.password);
      //print("seed: $seed");
      print("mnemonic: $mnemonic");
      print("STARTING NODE...");
      await _lightningNodeRepository.startNodeWithMnemonic(
          mnemonic: mnemonic.asString(),
          network: event.network.asLightningNodeRepositoryNetwork);
      print("NODE STARTED...");
      final nodeId = await _lightningNodeRepository.nodeId;
      print("node started with id: $nodeId");
      final nodeId2 = await _lightningNodeRepository.nodeId;
      print("node started with id 2222: $nodeId2");
      final balance = await _getSpendableBalance();
      print("node balance: $balance");
      emit(LightningNodeRunSuccess(
          network: event.network, nodeId: nodeId, balance: balance));
    } catch (e) {
      print("node start failed with error: $e");
      emit(const LightningNodeRunFailure());
    }
  }

  Future<void> _onPaymentEventReceived(
    PaymentEventReceived event,
    Emitter<LightningNodeState> emit,
  ) async {
    print('payment event received: $event');
    final balance = await _getSpendableBalance();
    if (state is LightningNodeRunSuccess) {
      emit((state as LightningNodeRunSuccess).copyWith(balance: balance));
    }
  }

  Future<void> _onChannelEventReceived(
    ChannelEventReceived event,
    Emitter<LightningNodeState> emit,
  ) async {
    print("channel event received: $event");
    final balance = await _getSpendableBalance();
    if (state is LightningNodeRunSuccess) {
      emit((state as LightningNodeRunSuccess).copyWith(balance: balance));
    }
  }

  Future<int> _getSpendableBalance() async {
    try {
      print("getting balance...");
      final balance = await _lightningNodeRepository.balance;
      print("in getting balance: $balance");
      return balance.totalOutboundCapacity;
    } catch (e) {
      print("in getting balance error: $e");
      throw FormatException("_getSpendableBalance failed with error: $e");
    }
  }
}
