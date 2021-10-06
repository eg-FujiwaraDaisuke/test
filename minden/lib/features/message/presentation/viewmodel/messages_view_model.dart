import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/features/message/domain/entities/messages.dart';

class MessagesViewModel extends StateNotifier<Messages> {
  MessagesViewModel(Messages initialMessages)
      : super(
          initialMessages,
        );

  void updateMessages(Messages newMessages) {
    state = Messages(
      showBadge: newMessages.showBadge,
      page: newMessages.page,
      total: newMessages.total,
      messages: newMessages.messages,
    );
  }

  void addMessageDetailList(List<MessageDetail> newMessageDetailList) {
    state = Messages(
      showBadge: state.showBadge,
      page: state.page,
      total: state.total,
      messages: [...newMessageDetailList, ...state.messages],
    );
  }

  void updateShowBadge(bool isShowBadge) {
    state = Messages(
      showBadge: isShowBadge,
      page: state.page,
      total: state.total,
      messages: state.messages,
    );
  }

  void toggleRead(int messageId) {
    state = Messages(
      showBadge: state.showBadge,
      page: state.page,
      total: state.total,
      messages: [
        for (final messageDetail in state.messages)
          if (messageDetail.messageId == messageId)
            MessageDetail(
                messageId: messageDetail.messageId,
                userId: messageDetail.userId,
                plantId: messageDetail.plantId,
                title: messageDetail.title,
                body: messageDetail.body,
                created: messageDetail.created,
                read: true,
                importance: messageDetail.importance,
                messageType: messageDetail.messageType)
          else
            messageDetail
      ],
    );
  }
}
