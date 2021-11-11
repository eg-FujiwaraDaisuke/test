// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessagesState _$_$_MessagesStateFromJson(Map<String, dynamic> json) {
  return _$_MessagesState(
    hasEverGetMessage: json['hasEverGetMessage'] as bool? ?? false,
    showBadge: json['showBadge'] as bool? ?? false,
    page: json['page'] as int? ?? 0,
    total: json['total'] as int? ?? 0,
    messages: (json['messages'] as List<dynamic>?)
            ?.map((e) => MessageDetail.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$_$_MessagesStateToJson(_$_MessagesState instance) =>
    <String, dynamic>{
      'hasEverGetMessage': instance.hasEverGetMessage,
      'showBadge': instance.showBadge,
      'page': instance.page,
      'total': instance.total,
      'messages': instance.messages,
    };
