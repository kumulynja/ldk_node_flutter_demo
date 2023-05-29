import 'package:flutter/material.dart';
import 'package:ldk_node_flutter_demo/app.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:seed_repository/seed_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final seedRepository = SeedRepository();
  final lightningNodeRepository = LightningNodeRepository();

  // Delete stored mnemonic to start with onboarding
  // comment out to keep the already stored mnemonic
  //  await seedRepository.deleteMnemonic();

  runApp(App(
      seedRepository: seedRepository,
      lightningNodeRepository: lightningNodeRepository));
}
