import 'package:minden/features/message/domain/entities/message_detail.dart';

class MessageDetailModel extends MessageDetail {
  const MessageDetailModel({
    required messageId,
    required userId,
    required plantId,
    required title,
    required body,
    required image,
    required created,
    required read,
    required importance,
    required messageType,
  }) : super(
          messageId: messageId,
          userId: userId,
          plantId: plantId,
          title: title,
          body: body,
          image: image,
          created: created,
          read: read,
          importance: importance,
          messageType: messageType,
        );

  factory MessageDetailModel.fromMessageDetail(MessageDetail messageDetail) {
    return MessageDetailModel(
      messageId: messageDetail.messageId,
      userId: messageDetail.userId,
      plantId: messageDetail.plantId,
      title: messageDetail.title,
      body: messageDetail.body,
      image: messageDetail.image,
      created: messageDetail.created,
      read: messageDetail.read,
      importance: messageDetail.importance,
      messageType: messageDetail.messageType,
    );
  }

  factory MessageDetailModel.fromJson(Map<String, dynamic> json) {
    return MessageDetailModel.fromMessageDetail(MessageDetail.fromJson(json));
  }
}
