import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'counter_state.dart';

///onPressedで呼び出して実行するやつ
///
class CounterStateController extends StateNotifier<CounterState> {
  CounterStateController() : super(const CounterState());
  increment() => state = state.copyWith(
        count: state.count + 1,
        count10: state.count10 + 10,
      );
}
