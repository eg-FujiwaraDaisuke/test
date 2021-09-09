import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/user/domain/usecases/update_profile.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';

class UpdateProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UpdateProfileBloc(ProfileState initialState, this.usecase)
      : super(initialState);
  final UpdateProfile usecase;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is UpdateProfileInfo) {
      try {
        yield const ProfileUpdating();

        final failureOrUser = await usecase(
            ProfileParams(event.name, event.icon, event.bio, event.wallPaper));

        yield failureOrUser.fold<ProfileState>(
          (failure) => throw ServerFailure(),
          (profile) => ProfileUpdated(profile: profile),
        );
      } catch (e) {
        yield ProfileUpdateError(e.toString());
      }
    }
  }
}
