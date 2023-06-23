import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/lightning_node/lightning_node_bloc.dart';
import 'package:ldk_node_flutter_demo/bloc/network/network_cubit.dart';
import 'package:ldk_node_flutter_demo/routes/routes.dart';
import 'package:ldk_node_flutter_demo/theme/app_theme.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';
import 'package:seed_repository/seed_repository.dart';

class App extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _seedRepository,
        ),
        RepositoryProvider.value(
          value: _lightningNodeRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _networkCubit,
          ),
          BlocProvider.value(
            value: _lightningNodeBloc,
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LDK Node Flutter Demo',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
