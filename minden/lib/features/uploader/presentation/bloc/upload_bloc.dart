import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/uploader/domain/usecases/media_usecase.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_event.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc(UploadState initialState, this.usecase) : super(initialState);
  final UploadMedia usecase;

  @override
  Stream<UploadState> mapEventToState(
    UploadEvent event,
  ) async* {
    if (event is UploadMediaEvent) {
      try {
        yield const Uploading();

        final failureOrUser = await usecase(MediaInfoParams(event.file));

        yield failureOrUser.fold<UploadState>(
          (failure) => throw failure,
          (media) => Uploaded(media: media),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield UploadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield UploadError(message: e.toString(), needLogin: false);
      }
    }
  }
}
