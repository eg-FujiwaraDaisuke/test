import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/profile_setting/domain/usecases/update_tag.dart';
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
          (failure) => throw ServerFailure(),
          (success) => const TagUpdated(),
        );
      } catch (e) {
        yield TagUpdateError(e.toString());
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

        yield failureOrUser.fold<TagState>((failure) => throw ServerFailure(),
            (category) => CategoryGetSucceed(category));
      } catch (e) {
        yield TagUpdateError(e.toString());
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

        final failureOrUser = await usecase(NoParams());

        yield failureOrUser.fold<TagState>(
            (failure) => throw ServerFailure(), (tags) => TagGetSucceed(tags));
      } catch (e) {
        yield TagUpdateError(e.toString());
      }
    }
  }
}
