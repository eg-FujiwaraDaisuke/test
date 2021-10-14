// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'messages_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessagesState _$MessagesStateFromJson(Map<String, dynamic> json) {
  return _MessagesState.fromJson(json);
}

/// @nodoc
class _$MessagesStateTearOff {
  const _$MessagesStateTearOff();

  _MessagesState call(
      {bool isInitialed = false,
      bool showBadge = false,
      int page = 0,
      int total = 0,
      List<MessageDetail> messages = const []}) {
    return _MessagesState(
      isInitialed: isInitialed,
      showBadge: showBadge,
      page: page,
      total: total,
      messages: messages,
    );
  }

  MessagesState fromJson(Map<String, Object> json) {
    return MessagesState.fromJson(json);
  }
}

/// @nodoc
const $MessagesState = _$MessagesStateTearOff();

/// @nodoc
mixin _$MessagesState {
  bool get isInitialed => throw _privateConstructorUsedError;
  bool get showBadge => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  List<MessageDetail> get messages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessagesStateCopyWith<MessagesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessagesStateCopyWith<$Res> {
  factory $MessagesStateCopyWith(
          MessagesState value, $Res Function(MessagesState) then) =
      _$MessagesStateCopyWithImpl<$Res>;
  $Res call(
      {bool isInitialed,
      bool showBadge,
      int page,
      int total,
      List<MessageDetail> messages});
}

/// @nodoc
class _$MessagesStateCopyWithImpl<$Res>
    implements $MessagesStateCopyWith<$Res> {
  _$MessagesStateCopyWithImpl(this._value, this._then);

  final MessagesState _value;
  // ignore: unused_field
  final $Res Function(MessagesState) _then;

  @override
  $Res call({
    Object? isInitialed = freezed,
    Object? showBadge = freezed,
    Object? page = freezed,
    Object? total = freezed,
    Object? messages = freezed,
  }) {
    return _then(_value.copyWith(
      isInitialed: isInitialed == freezed
          ? _value.isInitialed
          : isInitialed // ignore: cast_nullable_to_non_nullable
              as bool,
      showBadge: showBadge == freezed
          ? _value.showBadge
          : showBadge // ignore: cast_nullable_to_non_nullable
              as bool,
      page: page == freezed
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      total: total == freezed
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      messages: messages == freezed
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDetail>,
    ));
  }
}

/// @nodoc
abstract class _$MessagesStateCopyWith<$Res>
    implements $MessagesStateCopyWith<$Res> {
  factory _$MessagesStateCopyWith(
          _MessagesState value, $Res Function(_MessagesState) then) =
      __$MessagesStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isInitialed,
      bool showBadge,
      int page,
      int total,
      List<MessageDetail> messages});
}

/// @nodoc
class __$MessagesStateCopyWithImpl<$Res>
    extends _$MessagesStateCopyWithImpl<$Res>
    implements _$MessagesStateCopyWith<$Res> {
  __$MessagesStateCopyWithImpl(
      _MessagesState _value, $Res Function(_MessagesState) _then)
      : super(_value, (v) => _then(v as _MessagesState));

  @override
  _MessagesState get _value => super._value as _MessagesState;

  @override
  $Res call({
    Object? isInitialed = freezed,
    Object? showBadge = freezed,
    Object? page = freezed,
    Object? total = freezed,
    Object? messages = freezed,
  }) {
    return _then(_MessagesState(
      isInitialed: isInitialed == freezed
          ? _value.isInitialed
          : isInitialed // ignore: cast_nullable_to_non_nullable
              as bool,
      showBadge: showBadge == freezed
          ? _value.showBadge
          : showBadge // ignore: cast_nullable_to_non_nullable
              as bool,
      page: page == freezed
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      total: total == freezed
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      messages: messages == freezed
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageDetail>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_MessagesState implements _MessagesState {
  const _$_MessagesState(
      {this.isInitialed = false,
      this.showBadge = false,
      this.page = 0,
      this.total = 0,
      this.messages = const []});

  factory _$_MessagesState.fromJson(Map<String, dynamic> json) =>
      _$_$_MessagesStateFromJson(json);

  @JsonKey(defaultValue: false)
  @override
  final bool isInitialed;
  @JsonKey(defaultValue: false)
  @override
  final bool showBadge;
  @JsonKey(defaultValue: 0)
  @override
  final int page;
  @JsonKey(defaultValue: 0)
  @override
  final int total;
  @JsonKey(defaultValue: const [])
  @override
  final List<MessageDetail> messages;

  @override
  String toString() {
    return 'MessagesState(isInitialed: $isInitialed, showBadge: $showBadge, page: $page, total: $total, messages: $messages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MessagesState &&
            (identical(other.isInitialed, isInitialed) ||
                const DeepCollectionEquality()
                    .equals(other.isInitialed, isInitialed)) &&
            (identical(other.showBadge, showBadge) ||
                const DeepCollectionEquality()
                    .equals(other.showBadge, showBadge)) &&
            (identical(other.page, page) ||
                const DeepCollectionEquality().equals(other.page, page)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.messages, messages) ||
                const DeepCollectionEquality()
                    .equals(other.messages, messages)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isInitialed) ^
      const DeepCollectionEquality().hash(showBadge) ^
      const DeepCollectionEquality().hash(page) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(messages);

  @JsonKey(ignore: true)
  @override
  _$MessagesStateCopyWith<_MessagesState> get copyWith =>
      __$MessagesStateCopyWithImpl<_MessagesState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MessagesStateToJson(this);
  }
}

abstract class _MessagesState implements MessagesState {
  const factory _MessagesState(
      {bool isInitialed,
      bool showBadge,
      int page,
      int total,
      List<MessageDetail> messages}) = _$_MessagesState;

  factory _MessagesState.fromJson(Map<String, dynamic> json) =
      _$_MessagesState.fromJson;

  @override
  bool get isInitialed => throw _privateConstructorUsedError;
  @override
  bool get showBadge => throw _privateConstructorUsedError;
  @override
  int get page => throw _privateConstructorUsedError;
  @override
  int get total => throw _privateConstructorUsedError;
  @override
  List<MessageDetail> get messages => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MessagesStateCopyWith<_MessagesState> get copyWith =>
      throw _privateConstructorUsedError;
}
