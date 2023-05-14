import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/blocs/mnemonic/mnemonic_bloc.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/create_wallet_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/onboarding_completed_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/mnemonic_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/recovery_screen.dart';
import 'package:ldk_node_flutter_demo/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  late final MnemonicBloc _mnemonicBloc;

  @override
  void initState() {
    super.initState();
    _mnemonicBloc = MnemonicBloc();
  }

  @override
  Widget build(BuildContext context) {
    /// The route configuration.
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              child: Container(),
            );
          },
          redirect: (BuildContext context, GoRouterState state) {
            if (state.location == '/') {
              // Only redirect if it's a top-level route
              return '/onboarding';
            }
            return null;
          },
          routes: <GoRoute>[
            GoRoute(
              path: 'onboarding',
              name: 'onboarding',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return MaterialPage(
                  child: BlocProvider.value(
                    value: _mnemonicBloc,
                    child: const CreateWalletScreen(),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: 'mnemonic',
                  name: 'mnemonic',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return MaterialPage(
                      child: BlocProvider.value(
                        value: _mnemonicBloc,
                        child: const MnemonicScreen(),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'recovery',
                  name: 'recovery',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return MaterialPage(
                      child: BlocProvider.value(
                        value: _mnemonicBloc,
                        child: const RecoveryScreen(),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'completed',
                  name: 'onboarding-completed',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const MaterialPage(
                      child: OnboardingCompletedScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'LDK Node Flutter Demo',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }

  @override
  void dispose() {
    _mnemonicBloc.close();
    super.dispose();
  }
}
