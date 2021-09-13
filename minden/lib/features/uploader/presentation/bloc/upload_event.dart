import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();
}

class UploadMediaEvent extends UploadEvent {
  const UploadMediaEvent(this.file);

  final File file;

  @override
  List<Object> get props => [file];
}
