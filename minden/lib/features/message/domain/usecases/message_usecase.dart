import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/message/domain/entities/message.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/features/message/domain/repositories/message_repository.dart';

class GetMessages extends UseCase<Messages, GetMessagesParams> {
  GetMessages(this.repository);
  final MessageRepository repository;

  @override
  Future<Either<Failure, Messages>> call(GetMessagesParams params) async {
    return await repository.getMessages(params.page);
  }
}

class GetMessageDetail extends UseCase<MessageDetail, GetMessageDetailParams> {
  GetMessageDetail(this.repository);
  final MessageRepository repository;

  @override
  Future<Either<Failure, MessageDetail>> call(
      GetMessageDetailParams params) async {
    return await repository.getMessageDetail(messageId: params.messageId);
  }
}

class ReadMessage extends UseCase<Success, ReadMessageParams> {
  ReadMessage(this.repository);
  final MessageRepository repository;

  @override
  Future<Either<Failure, Success>> call(ReadMessageParams params) async {
    return await repository.readMessage(messageId: params.messageId);
  }
}

class GetMessagesParams extends Equatable {
  const GetMessagesParams(this.page);
  final String page;

  @override
  List<Object> get props => [];
}

class GetMessageDetailParams extends Equatable {
  const GetMessageDetailParams(this.messageId);
  final int messageId;

  @override
  List<Object> get props => [messageId];
}

class ReadMessageParams extends Equatable {
  const ReadMessageParams(this.messageId);
  final int messageId;

  @override
  List<Object> get props => [messageId];
}
