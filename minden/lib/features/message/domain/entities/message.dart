import 'package:equatable/equatable.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';

class Messages extends Equatable {
  const Messages({
    required this.showBadge,
    required this.page,
    required this.total,
    required this.messages,
  });

  factory Messages.fromJson(Map<String, dynamic> elem) {
    final List<MessageDetail> messages =
        elem['messages']?.map<MessageDetail>((e) {
              return MessageDetail.fromJson(e);
            }).toList() ??
            [];

    return Messages(
      showBadge: elem['showBadge'],
      page: elem['page'],
      total: elem['total'],
      messages: messages,
    );
  }

  final bool showBadge;
  final int page;
  final int total;
  final List<MessageDetail> messages;

  Map<String, dynamic> toJson() {
    return {
      'showBadge': showBadge,
      'page': page,
      'total': total,
      'messages': messages.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object> get props => [];
}
