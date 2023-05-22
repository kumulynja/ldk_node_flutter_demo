import 'package:flutter/material.dart';
import 'package:ldk_node_flutter_demo/app.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:mnemonic_repository/mnemonic_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mnemonicRepository = MnemonicRepository();
  final lightningNodeRepository = LightningNodeRepository();

  // Delete stored mnemonic to start with onboarding
  // comment out to keep the already stored mnemonic
  // await mnemonicRepository.deleteMnemonic();

  runApp(App(
      mnemonicRepository: mnemonicRepository,
      lightningNodeRepository: lightningNodeRepository));
}
