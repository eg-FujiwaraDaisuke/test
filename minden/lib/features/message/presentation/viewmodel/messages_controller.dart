import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/features/message/domain/entities/messages.dart';
import 'messages_state.dart';

class MessagesStateController extends StateNotifier<MessagesState> {
  MessagesStateController() : super(const MessagesState());
  updateMessages(Messages messages) {
    state = state.copyWith(
      showBadge: messages.showBadge,
      page: messages.page,
      total: messages.total,
      messages: messages.messages,
    );
  }

  addMessages(Messages messages) {
    state = state.copyWith(
      showBadge: messages.showBadge,
      page: messages.page,
      total: messages.total,
      // メッセージの重複削除
      messages: [
        ...{...state.messages, ...messages.messages}
      ],
    );
  }

  updateShowBadge(Messages messages) {
    state = state.copyWith(
      showBadge: messages.showBadge,
      total: messages.total,
    );
  }

  readMessage(int messageId) {
    state = state.copyWith(
      messages: state.messages.map((messageDetail) {
        return messageDetail.messageId == messageId
            ? MessageDetail(
                messageId: messageDetail.messageId,
                userId: messageDetail.userId,
                plantId: messageDetail.plantId,
                title: messageDetail.title,
                body: messageDetail.body,
                created: messageDetail.created,
                read: true,
                importance: messageDetail.importance,
                messageType: messageDetail.messageType)
            : messageDetail;
      }).toList(),
    );
  }
}
