import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/message/domain/entities/message.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/features/message/domain/usecases/message_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class GetMessagesBloc extends Bloc<MessageEvent, MessageState> {
  GetMessagesBloc(MessageState initialState, this.usecase)
      : super(initialState);
  final GetMessages usecase;

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is GetMessagesEvent) {
      try {
        yield const MessagesLoading();

        final failureOrUser =
            await usecase(GetMessagesParams(event.page ?? '1'));

        yield failureOrUser.fold<MessageState>(
          (failure) => throw failure,
          (messages) => MessagesLoaded(messages),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield MessageError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield MessageError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetMessageDetailBloc extends Bloc<MessageEvent, MessageState> {
  GetMessageDetailBloc(MessageState initialState, this.usecase)
      : super(initialState);
  final GetMessageDetail usecase;

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is GetMessageDetailEvent) {
      try {
        yield const MessageDetailLoading();

        final failureOrUser =
            await usecase(GetMessageDetailParams(event.messageId));

        yield failureOrUser.fold<MessageState>(
          (failure) => throw failure,
          (messageDetail) => MessageDetailLoaded(messageDetail),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield MessageError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield MessageError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class ReadMessageBloc extends Bloc<MessageEvent, MessageState> {
  ReadMessageBloc(MessageState initialState, this.usecase)
      : super(initialState);
  final ReadMessage usecase;

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is ReadMessageEvent) {
      yield const MessageReading();
      final failureOrSuccess =
          await usecase(ReadMessageParams(event.messageId));

      yield failureOrSuccess.fold(
        (failure) => throw failure,
        (success) => const MessageReaded(),
      );

      try {} on RefreshTokenExpiredException catch (e) {
        yield MessageError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield MessageError(message: e.toString(), needLogin: false);
      }
    }
  }
}
