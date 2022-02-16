import 'package:minden/features/message/domain/entities/messages.dart';

class MessagesModel extends Messages {
  const MessagesModel({
    required showBadge,
    required page,
    required total,
    required messages,
  }) : super(
          showBadge: showBadge,
          page: page,
          total: total,
          messages: messages,
        );

  factory MessagesModel.fromMessages(Messages messages) {
    return MessagesModel(
      showBadge: messages.showBadge,
      page: messages.page,
      total: messages.total,
      messages: messages.messages,
    );
  }

  factory MessagesModel.fromJson(Map<String, dynamic> messages) {
    return MessagesModel.fromMessages(Messages.fromJson(messages));
  }
}
