import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class UpdateProfileInfo extends ProfileEvent {
  const UpdateProfileInfo(
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
