import 'package:equatable/equatable.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileStateInitial extends ProfileState {
  const ProfileStateInitial();

  @override
  List<Object> get props => [];
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating();

  @override
  List<Object> get props => [];
}

class ProfileUpdated extends ProfileState {
  const ProfileUpdated({required this.profile});

  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object> get props => [message];
}
