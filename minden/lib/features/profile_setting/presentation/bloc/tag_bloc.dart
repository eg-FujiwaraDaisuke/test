import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/profile_setting/domain/usecases/tag_usecase.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_event.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';

class UpdateTagBloc extends Bloc<TagEvent, TagState> {
  UpdateTagBloc(TagState initialState, this.usecase) : super(initialState);
  final UpdateTags usecase;

  @override
  Stream<TagState> mapEventToState(
    TagEvent event,
  ) async* {
    if (event is UpdateTagEvent) {
      try {
        yield const TagLoading();

        final failureOrUser = await usecase(UpdateTagParams(event.tags));

        yield failureOrUser.fold<TagState>(
          (failure) => throw failure,
          (success) => const TagUpdated(),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetAllTagsBloc extends Bloc<TagEvent, TagState> {
  GetAllTagsBloc(TagState initialState, this.usecase) : super(initialState);
  final GetAllTags usecase;

  @override
  Stream<TagState> mapEventToState(
    TagEvent event,
  ) async* {
    if (event is GetTagEvent) {
      try {
        yield const TagLoading();

        final failureOrUser = await usecase(NoParams());

        yield failureOrUser.fold<TagState>((failure) => throw failure,
            (category) {
          return CategoryGetSucceed(category);
        });
      } on RefreshTokenExpiredException catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetTagsBloc extends Bloc<TagEvent, TagState> {
  GetTagsBloc(TagState initialState, this.usecase) : super(initialState);
  final GetTags usecase;

  @override
  Stream<TagState> mapEventToState(
    TagEvent event,
  ) async* {
    if (event is GetTagEvent) {
      try {
        yield const TagLoading();

        final failureOrUser = await usecase(GetTagParams(userId: event.userId));

        yield failureOrUser.fold<TagState>((failure) => throw failure, (tags) {
          return TagGetSucceed(tags);
        });
      } on RefreshTokenExpiredException catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetPlantTagsBloc extends Bloc<TagEvent, TagState> {
  GetPlantTagsBloc(TagState initialState, this.usecase) : super(initialState);
  final GetPlantTags usecase;

  @override
  Stream<TagState> mapEventToState(
    TagEvent event,
  ) async* {
    if (event is GetTagEvent) {
      try {
        yield const TagLoading();

        final failureOrUser =
            await usecase(GetTagParams(plantId: event.plantId));

        yield failureOrUser.fold<TagState>((failure) => throw failure, (tags) {
          return TagGetSucceed(tags);
        });
      } on RefreshTokenExpiredException catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: false);
      }
    }
  }
}

class GetPlantsTagsBloc extends Bloc<TagEvent, TagState> {
  GetPlantsTagsBloc(TagState initialState, this.usecase) : super(initialState);
  final GetPlantsTags usecase;

  @override
  Stream<TagState> mapEventToState(
    TagEvent event,
  ) async* {
    if (event is GetTagEvent) {
      try {
        yield const TagLoading();

        final failureOrUser = await usecase(NoParams());

        yield failureOrUser.fold<TagState>((failure) => throw failure, (tags) {
          return TagGetSucceed(tags);
        });
      } on RefreshTokenExpiredException catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield TagUpdateError(message: e.toString(), needLogin: false);
      }
    }
  }
}
