import 'package:equatable/equatable.dart';
import 'package:minden/features/uploader/domain/entities/media.dart';

abstract class UploadState extends Equatable {
  const UploadState();
}

class UploadInitial extends UploadState {
  const UploadInitial();

  @override
  List<Object> get props => [];
}

class Uploading extends UploadState {
  const Uploading();

  @override
  List<Object> get props => [];
}

class Uploaded extends UploadState {
  const Uploaded({required this.media});

  final Media media;

  @override
  List<Object> get props => [media];
}

class UploadError extends UploadState {
  const UploadError({
    required this.message,
    required this.needLogin,
  });

  final String message;
  final bool needLogin;

  @override
  List<Object> get props => [message];
}
