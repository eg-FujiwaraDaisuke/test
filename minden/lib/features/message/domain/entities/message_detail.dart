import 'package:equatable/equatable.dart';

class MessageDetail extends Equatable {
  const MessageDetail({
    required this.messageId,
    required this.userId,
    required this.plantId,
    required this.title,
    required this.body,
    required this.image,
    required this.created,
    required this.read,
    required this.importance,
    required this.messageType,
  });

  factory MessageDetail.fromJson(Map<String, dynamic> messageDetail) {
    return MessageDetail(
      messageId: messageDetail['messageId'],
      userId: messageDetail['userId'],
      plantId: messageDetail['plantId'],
      title: messageDetail['title'],
      body: messageDetail['body'],
      image: messageDetail['image'],
      created: messageDetail['created'],
      read: messageDetail['read'],
      importance: messageDetail['importance'],
      messageType: messageDetail['messageType'],
    );
  }
  final int messageId;
  final String userId;
  final String plantId;
  final String title;
  final String body;
  final String? image;
  final int created;
  final bool read;
  final String importance;

  // "messageType":"1"がみんな電力からのメッセージ
  final String messageType;

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'userId': userId,
      'plantId': plantId,
      'title': title,
      'body': body,
      'image': image,
      'created': created,
      'read': read,
      'importance': importance,
      'messageType': messageType,
    };
  }

  @override
  List<Object> get props => [
        messageId,
      ];
}
