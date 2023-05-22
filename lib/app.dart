import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/create_wallet_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/onboarding_completed_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/mnemonic_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/recovery_screen.dart';
import 'package:ldk_node_flutter_demo/theme/app_theme.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:mnemonic_repository/mnemonic_repository.dart';

class App extends StatefulWidget {
  const App(
      {required MnemonicRepository mnemonicRepository,
      required LightningNodeRepository lightningNodeRepository,
      super.key})
      : _mnemonicRepository = mnemonicRepository,
        _lightningNodeRepository = lightningNodeRepository;

  final MnemonicRepository _mnemonicRepository;
  final LightningNodeRepository _lightningNodeRepository;

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  // Add blocs here that needs to be shared between screens
  // late final ...Bloc _...Bloc;

  @override
  void initState() {
    super.initState();
    // init blocs here that need to be shared between screens
    // _...Bloc = ...Bloc();
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
            return const MaterialPage(
              child: Center(
                child: Text("WELCOME HOME!!!"),
              ),
            );
          },
          redirect: (BuildContext context, GoRouterState state) async {
            if (state.location == '/') {
              // Only redirect if it's a top-level route
              if (!(await widget._mnemonicRepository.doesMnemonicExist())) {
                // If no mnemonic exists, onboarding should be done to create
                //  or restore one.
                return '/onboarding';
              }
            }
            return null;
          },
          routes: <GoRoute>[
            GoRoute(
              path: 'onboarding',
              name: 'onboarding',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const MaterialPage(
                  child: CreateWalletScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: 'mnemonic',
                  name: 'mnemonic',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const MaterialPage(
                      child: MnemonicScreen(),
                    );
                  },
                ),
                GoRoute(
                  path: 'recovery',
                  name: 'recovery',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const MaterialPage(
                      child: RecoveryScreen(),
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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: widget._mnemonicRepository,
        ),
        RepositoryProvider.value(
          value: widget._lightningNodeRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => LightningNodeBloc(
          lightningNodeRepository: widget._lightningNodeRepository,
        ),
        child: MaterialApp.router(
          title: 'LDK Node Flutter Demo',
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Close blocs that are used over different screens here
    //_...Bloc.close();
    super.dispose();
  }
}
