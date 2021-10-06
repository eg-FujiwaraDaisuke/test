import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'counter_controller.dart';
import 'counter_state.dart';

//このProviderがあるおかげで、countが変更したときの状態を監視できる
final counterStateControllerProvider =
    StateNotifierProvider<CounterStateController, CounterState>(
        (ref) => CounterStateController());
