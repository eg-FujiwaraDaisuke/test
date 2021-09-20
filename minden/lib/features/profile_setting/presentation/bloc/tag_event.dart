import 'package:equatable/equatable.dart';

abstract class TagEvent extends Equatable {
  const TagEvent();
}

class UpdateTagEvent extends TagEvent {
  const UpdateTagEvent({
    required this.tags,
  });

  final List<int> tags;

  @override
  List<Object> get props => [tags];
}

class GetTagEvent extends TagEvent {
  GetTagEvent({
    this.userId,
  });

  String? userId;

  @override
  List<Object> get props => [];
}
