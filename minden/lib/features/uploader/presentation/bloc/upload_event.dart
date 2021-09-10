import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();
}

class UploadMediaInfo extends UploadEvent {
  const UploadMediaInfo(this.file);

  final File file;

  @override
  List<Object> get props => [file];
}
