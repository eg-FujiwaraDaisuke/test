import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';

class GetProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  GetProfileBloc(ProfileState initialState, this.usecase) : super(initialState);
  final GetProfile usecase;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfileEvent) {
      try {
        yield const ProfileLoading();

        final failureOrUser = await usecase(GetProfileParams(event.userId));

        yield failureOrUser.fold<ProfileState>(
          (failure) => throw failure,
          (profile) => ProfileLoaded(profile: profile),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield ProfileLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield ProfileLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class UpdateProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UpdateProfileBloc(ProfileState initialState, this.usecase)
      : super(initialState);
  final UpdateProfile usecase;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is UpdateProfileEvent) {
      try {
        yield const ProfileLoading();

        final failureOrUser = await usecase(
          UpdateProfileParams(
            event.name,
            event.icon,
            event.bio,
            event.wallPaper,
          ),
        );

        yield failureOrUser.fold<ProfileState>(
          (failure) => throw failure,
          (profile) {
            return ProfileLoaded(profile: profile);
          },
        );
      } on RefreshTokenExpiredException catch (e) {
        yield ProfileLoadError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield ProfileLoadError(message: e.toString(), needLogin: false);
      }
    }
  }
}
