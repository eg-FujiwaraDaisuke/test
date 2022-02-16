part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class GetMessagesEvent extends MessageEvent {
  GetMessagesEvent(
    this.page,
  );

  String? page;

  @override
  List<Object> get props => [];
}

class GetMessageDetailEvent extends MessageEvent {
  const GetMessageDetailEvent({required this.messageId});

  final String messageId;

  @override
  List<Object> get props => [messageId];
}

class GetShowBadgeEvent extends MessageEvent {
  GetShowBadgeEvent(
    this.page,
  );

  String? page;

  @override
  List<Object> get props => [];
}

class ReadMessageEvent extends MessageEvent {
  const ReadMessageEvent({required this.messageId});

  final int messageId;

  @override
  List<Object> get props => [messageId];
}
