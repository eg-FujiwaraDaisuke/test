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
  const UpdateProfileEvent({
    required this.name,
    required this.icon,
    required this.bio,
    required this.wallPaper,
    required this.freeLink,
    required this.twitterLink,
    required this.facebookLink,
    required this.instagramLink,
  });

  final String name;
  final String icon;
  final String bio;
  final String wallPaper;
  final String freeLink;
  final String twitterLink;
  final String facebookLink;
  final String instagramLink;

  @override
  List<Object> get props => [name];
}
