import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/blocs/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/network/network_cubit.dart';
import 'package:ldk_node_flutter_demo/screens/lightning_wallet/lightning_wallet_home_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/create_wallet_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/onboarding_completed_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/mnemonic_screen.dart';
import 'package:ldk_node_flutter_demo/screens/onboarding/recovery_screen.dart';
import 'package:ldk_node_flutter_demo/theme/app_theme.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:seed_repository/seed_repository.dart';

class App extends StatefulWidget {
  const App({
    required SeedRepository seedRepository,
    required LightningNodeRepository lightningNodeRepository,
    required NetworkCubit networkCubit,
    required LightningNodeBloc lightningNodeBloc,
    super.key,
  })  : _seedRepository = seedRepository,
        _lightningNodeRepository = lightningNodeRepository,
        _networkCubit = networkCubit,
        _lightningNodeBloc = lightningNodeBloc;

  final SeedRepository _seedRepository;
  final LightningNodeRepository _lightningNodeRepository;
  final NetworkCubit _networkCubit;
  final LightningNodeBloc _lightningNodeBloc;

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
              child: LightningWalletHomeScreen(),
            );
          },
          redirect: (BuildContext context, GoRouterState state) async {
            if (state.location == '/') {
              // Only redirect if it's a top-level route
              if (!(await widget._seedRepository.doesMnemonicExist())) {
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
          value: widget._seedRepository,
        ),
        RepositoryProvider.value(
          value: widget._lightningNodeRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: widget._networkCubit,
          ),
          BlocProvider.value(
            value: widget._lightningNodeBloc,
          ),
        ],
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
