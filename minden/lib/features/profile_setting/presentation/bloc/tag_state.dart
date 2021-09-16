import 'package:equatable/equatable.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';

abstract class TagState extends Equatable {
  const TagState();
}

class TagStateInitial extends TagState {
  const TagStateInitial();

  @override
  List<Object> get props => [];
}

class TagGetSucceed extends TagState {
  const TagGetSucceed(this.tags);

  final List<Tag> tags;

  @override
  List<Object> get props => [tags];
}

class CategoryGetSucceed extends TagState {
  const CategoryGetSucceed(this.category);

  final List<TagCategory> category;

  @override
  List<Object> get props => [category];
}

class TagLoading extends TagState {
  const TagLoading();

  @override
  List<Object> get props => [];
}

class TagUpdated extends TagState {
  const TagUpdated();

  @override
  List<Object> get props => [];
}

class TagUpdateError extends TagState {
  const TagUpdateError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
