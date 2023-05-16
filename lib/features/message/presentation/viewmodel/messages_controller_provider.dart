import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'messages_controller.dart';
import 'messages_state.dart';

final messagesStateControllerProvider =
    StateNotifierProvider<MessagesStateController, MessagesState>(
        (ref) => MessagesStateController());
