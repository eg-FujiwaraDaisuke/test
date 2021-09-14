import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  const UpdateProfileEvent(
      {required this.name,
      required this.icon,
      required this.bio,
      required this.wallPaper});

  final String name;
  final String icon;
  final String bio;
  final String wallPaper;

  @override
  List<Object> get props => [name];
}
