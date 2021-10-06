import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/message/data/datasources/message_datasource.dart';
import 'package:minden/features/message/domain/entities/messages.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/features/message/domain/repositories/message_repository.dart';

class MessageRepositoryImpl
    with RetryProcessMixin
    implements MessageRepository {
  const MessageRepositoryImpl({required this.dataSource});

  final MessageDataSource dataSource;

  @override
  Future<Either<Failure, Messages>> getMessages(String page) async {
    try {
      final messages = await retryRequest(() => dataSource.getMessages(page));
      return Right(messages);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MessageDetail>> getMessageDetail(
      {required int messageId}) async {
    try {
      final messageDetail = await retryRequest(
          () => dataSource.getMessageDetail(messageId: messageId));
      return Right(messageDetail);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> readMessage({required int messageId}) async {
    try {
      final success = await retryRequest(
          () => dataSource.readMessage(messageId: messageId));
      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
