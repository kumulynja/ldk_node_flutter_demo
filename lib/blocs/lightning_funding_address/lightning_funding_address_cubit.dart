import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class LightningFundingAddressCubit extends Cubit<String> {
  LightningFundingAddressCubit({
    required LightningNodeRepository lightningNodeRepository,
  })  : _lightningNodeRepository = lightningNodeRepository,
        super('');

  final LightningNodeRepository _lightningNodeRepository;

  Future<void> newAddress() async {
    try {
      final address = await _lightningNodeRepository.newFundingAddress;
      emit(address);
    } catch (e) {
      print("newAddress failed with error: $e");
    }
  }
}
