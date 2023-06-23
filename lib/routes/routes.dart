import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/screens/splash_screen.dart';
import 'package:ldk_node_flutter_demo/routes/onboarding_routes.dart';
import 'package:ldk_node_flutter_demo/routes/lightning_routes.dart';
import 'package:seed_repository/seed_repository.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const MaterialPage(
          child: SplashScreen(),
        );
      },
      redirect: (BuildContext context, GoRouterState state) async {
        if (state.location == '/') {
          // Only redirect if it's a top-level route
          if (await RepositoryProvider.of<SeedRepository>(context)
              .doesMnemonicExist()) {
            return '/lightning';
          }
          // If no mnemonic exists, onboarding should be done to create
          //  or restore one.
          return '/onboarding';
        }
        return null;
      },
      routes: onboardingRoutes, // Subroutes for onboarding
    ),
    // Top-level route for Lightning Wallet
    lightningRoutes,
  ],
);
