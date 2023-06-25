import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_event.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_state.dart';
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
      await _lightningNodeRepository.startNodeWithMnemonic(
        mnemonic: mnemonic.asString(),
        network: event.network.asLightningNodeRepositoryNetwork,
      );
      emit(
        LightningNodeRunSuccess(
          network: event.network,
          nodeId: await _lightningNodeRepository.nodeId,
          listeningIp: await _lightningNodeRepository.listeningIp,
          listeningPort: await _lightningNodeRepository.listeningPort,
          onChainBalance: await _lightningNodeRepository.onChainBalance,
          channels: await _lightningNodeRepository.channels,
          payments: await _lightningNodeRepository.payments,
        ),
      );
      if (kDebugMode) {
        print('node started in state: ${state.toString()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("node start failed with error: $e");
      }
      emit(const LightningNodeRunFailure());
    }
  }

  Future<void> _onLightningNodeRefreshed(
    LightningNodeRefreshed event,
    Emitter<LightningNodeState> emit,
  ) async {
    if (state is LightningNodeRunSuccess) {
      emit((state as LightningNodeRunSuccess).copyWith(
        onChainBalance: await _lightningNodeRepository.onChainBalance,
        channels: await _lightningNodeRepository.channels,
        payments: await _lightningNodeRepository.payments,
      ));

      if (kDebugMode) {
        final onChainBalance =
            (state as LightningNodeRunSuccess).onChainBalance;
        print(
            'onChainBalance untrustedPending: ${onChainBalance.untrustedPending}');
        print(
            'onChainBalance trustedPending: ${onChainBalance.trustedPending}');
        print('onChainBalance confirmed: ${onChainBalance.confirmed}');
        print('onChainBalance immature: ${onChainBalance.immature}');

        final channels = (state as LightningNodeRunSuccess).channels;
        for (var e in channels) {
          print('channel id: ${e.channelId.asHex}');
          print('channel is public: ${e.isPublic}');
          print('channel is channel ready: ${e.isChannelReady}');
          print('channel is usable: ${e.isUsable}');
        }

        final payments = (state as LightningNodeRunSuccess).payments;
        for (var e in payments) {
          print('payment hash: ${e.hash.field0.asHex}');
          print('payment status: ${e.status.name}');
          print('payment amountMsat: ${e.amountMsat}');
          print('payment direction: ${e.direction.name}');
        }
      }
    }
  }

  Future<void> _onPaymentEventReceived(
    PaymentEventReceived event,
    Emitter<LightningNodeState> emit,
  ) async {
    if (state is LightningNodeRunSuccess) {
      emit((state as LightningNodeRunSuccess).copyWith(
        channels: await _lightningNodeRepository.channels,
        payments: await _lightningNodeRepository.payments,
      ));

      if (kDebugMode) {
        final channels = (state as LightningNodeRunSuccess).channels;
        final payments = (state as LightningNodeRunSuccess).payments;
        for (var e in channels) {
          print('channel id: ${e.channelId.asHex}');
          print('channel is public: ${e.isPublic}');
          print('channel is channel ready: ${e.isChannelReady}');
          print('channel is usable: ${e.isUsable}');
        }
        for (var e in payments) {
          print('payment hash: ${e.hash.field0}');
          print('payment status: ${e.status.name}');
          print('payment amountMsat: ${e.amountMsat}');
          print('payment direction: ${e.direction.name}');
        }
      }
    }
  }

  Future<void> _onChannelEventReceived(
    ChannelEventReceived event,
    Emitter<LightningNodeState> emit,
  ) async {
    if (state is LightningNodeRunSuccess) {
      emit(
        (state as LightningNodeRunSuccess).copyWith(
          onChainBalance: await _lightningNodeRepository.onChainBalance,
          channels: await _lightningNodeRepository.channels,
          payments: await _lightningNodeRepository.payments,
        ),
      );

      if (kDebugMode) {
        final onChainBalance =
            (state as LightningNodeRunSuccess).onChainBalance;
        print(
            'onChainBalance untrustedPending: ${onChainBalance.untrustedPending}');
        print(
            'onChainBalance trustedPending: ${onChainBalance.trustedPending}');
        print('onChainBalance confirmed: ${onChainBalance.confirmed}');
        print('onChainBalance immature: ${onChainBalance.immature}');
        final channels = (state as LightningNodeRunSuccess).channels;
        for (var e in channels) {
          print('channel id: ${e.channelId.asHex}');
          print('channel is public: ${e.isPublic}');
          print('channel is channel ready: ${e.isChannelReady}');
          print('channel is usable: ${e.isUsable}');
        }
        final payments = (state as LightningNodeRunSuccess).payments;
        for (var e in payments) {
          print('payment hash: ${e.hash.field0}');
          print('payment status: ${e.status.name}');
          print('payment amountMsat: ${e.amountMsat}');
          print('payment direction: ${e.direction.name}');
        }
      }
    }
  }
}
