import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
part 'messages_state.freezed.dart';
part 'messages_state.g.dart';

@freezed
abstract class MessagesState with _$MessagesState {
  const factory MessagesState({
    @Default(false) bool isInitialed,
    @Default(false) bool showBadge,
    @Default(0) int page,
    @Default(0) int total,
    @Default([]) List<MessageDetail> messages,
  }) = _MessagesState;

  factory MessagesState.fromJson(Map<String, dynamic> json) =>
      _$MessagesStateFromJson(json);
}
