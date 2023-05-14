import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:ldk_node_flutter_demo/blocs/recovery/recovery_event.dart';
import 'package:ldk_node_flutter_demo/blocs/recovery/recovery_state.dart';

class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  RecoveryBloc() : super(RecoveryInitial());
}
