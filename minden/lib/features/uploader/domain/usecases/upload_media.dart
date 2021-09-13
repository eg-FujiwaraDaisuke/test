import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/uploader/domain/entities/media.dart';
import 'package:minden/features/uploader/domain/repositories/media_repository.dart';

// domain - usecase

class UploadMedia extends UseCase<Media, MediaInfoParams> {
  UploadMedia(this.repository);

  final MediaRepository repository;

  @override
  Future<Either<Failure, Media>> call(MediaInfoParams params) async {
    return repository.upload(params.file);
  }
}

class MediaInfoParams extends Equatable {
  const MediaInfoParams(this.file);

  final File file;

  @override
  List<Object> get props => [file];
}
