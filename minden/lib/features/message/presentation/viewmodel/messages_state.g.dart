// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessagesState _$_$_MessagesStateFromJson(Map<String, dynamic> json) {
  return _$_MessagesState(
    showBadge: json['showBadge'] as bool? ?? false,
    page: json['page'] as int? ?? 1,
    total: json['total'] as int? ?? 1,
    messages: (json['messages'] as List<dynamic>?)
            ?.map((e) => MessageDetail.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$_$_MessagesStateToJson(_$_MessagesState instance) =>
    <String, dynamic>{
      'showBadge': instance.showBadge,
      'page': instance.page,
      'total': instance.total,
      'messages': instance.messages,
    };
