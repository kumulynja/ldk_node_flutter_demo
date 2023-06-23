import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/wallet_creation_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/mnemonic_generation_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/onboarding_completed_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/wallet_recovery_screen.dart';

List<RouteBase> onboardingRoutes = <GoRoute>[
  GoRoute(
    path: 'onboarding',
    name: 'onboarding',
    pageBuilder: (BuildContext context, GoRouterState state) {
      return const MaterialPage(
        child: WalletCreationScreen(),
      );
    },
    routes: [
      GoRoute(
        path: 'mnemonic-generation',
        name: 'mnemonic-generation',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(
            child: MnemonicGenerationScreen(),
          );
        },
      ),
      GoRoute(
        path: 'wallet-recovery',
        name: 'wallet-recovery',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(
            child: WalletRecoveryScreen(),
          );
        },
      ),
      GoRoute(
        path: 'onboarding-completed',
        name: 'onboarding-completed',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(
            child: OnboardingCompletedScreen(),
          );
        },
      ),
    ],
  ),
];
