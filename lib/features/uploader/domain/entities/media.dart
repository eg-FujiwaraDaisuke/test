import 'package:equatable/equatable.dart';

class Media extends Equatable {
  const Media({
    required this.contentId,
    required this.url,
  });

  final String contentId;
  final String url;

  @override
  List<Object> get props => [contentId];
}
