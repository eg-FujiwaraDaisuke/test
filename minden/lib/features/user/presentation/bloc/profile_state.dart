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

class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object> get props => [];
}
class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.profile});

  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class ProfileLoadError extends ProfileState {
  const ProfileLoadError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
