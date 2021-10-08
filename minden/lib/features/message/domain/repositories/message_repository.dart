import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/message/domain/entities/messages.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';

abstract class MessageRepository {
  Future<Either<Failure, Messages>> getMessages(String page);
  Future<Either<Failure, MessageDetail>> getMessageDetail(
      {required int messageId});
  Future<Either<Failure, Success>> readMessage({required int messageId});
}
