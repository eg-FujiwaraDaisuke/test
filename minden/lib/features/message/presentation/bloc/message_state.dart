part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitial extends MessageState {
  const MessageInitial();
  @override
  List<Object> get props => [];
}

class MessagesLoading extends MessageState {
  const MessagesLoading();
  @override
  List<Object> get props => [];
}

class MessageDetailLoading extends MessageState {
  const MessageDetailLoading();
  @override
  List<Object> get props => [];
}

class ShowBadgeLoading extends MessageState {
  const ShowBadgeLoading();
  @override
  List<Object> get props => [];
}

class MessageReading extends MessageState {
  const MessageReading();
  @override
  List<Object> get props => [];
}

class MessagesLoaded extends MessageState {
  const MessagesLoaded(this.messages);
  final Messages messages;
  @override
  List<Object> get props => [];
}

class MessageDetailLoaded extends MessageState {
  const MessageDetailLoaded(this.messageDetail);
  final MessageDetail messageDetail;
  @override
  List<Object> get props => [];
}

class ShowBadgeLoaded extends MessageState {
  const ShowBadgeLoaded(this.messages);
  final Messages messages;
  @override
  List<Object> get props => [];
}

class MessageReaded extends MessageState {
  const MessageReaded();
  @override
  List<Object> get props => [];
}

class MessagesPushNotifyLoaded extends MessageState {
  const MessagesPushNotifyLoaded(this.messages);
  final Messages messages;
  @override
  List<Object> get props => [];
}

class MessagesBackgroundPushNotifyLoaded extends MessageState {
  const MessagesBackgroundPushNotifyLoaded(this.messages);
  final Messages messages;
  @override
  List<Object> get props => [];
}

class MessageError extends MessageState {
  const MessageError({
    required this.message,
    required this.needLogin,
  });

  final String message;
  final bool needLogin;

  @override
  List<Object> get props => [message];
}
