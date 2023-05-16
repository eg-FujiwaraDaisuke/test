import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/uploader/domain/entities/media.dart';

// domain - repository

abstract class MediaRepository {
  Future<Either<Failure, Media>> upload(File file);
}
