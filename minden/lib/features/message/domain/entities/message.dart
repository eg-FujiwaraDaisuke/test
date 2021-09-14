class UserMessage {
  UserMessage({
    required this.showBadge,
    required this.page,
    required this.total,
    required this.messages,
  });

  final bool showBadge;
  final int page;
  final int total;
  final List<Message> messages;
}

class Message {
  Message({
    required this.messageId,
    required this.userId,
    required this.plantId,
    required this.title,
    required this.body,
    required this.image,
    required this.created,
    required this.read,
    required this.importance,
    required this.messageType,
  });

  final int messageId;
  final String userId;
  final String plantId;
  final String title;
  final String body;
  final String image;
  final int created;
  final bool read;
  final String importance;
  final String messageType;
}

final userMessageDammy = UserMessage(
  showBadge: true,
  page: 1,
  total: 6,
  messages: [
    Message(
      messageId: 1,
      userId: 'userId',
      plantId: 'plantId',
      title: 'title',
      body:
          '今月の応援先発電所が確定しました。\n応援先発電所はマイページから確認できます。\n引き続き、みんな電力の\n 「顔の見える電力」をお楽しみください！',
      image: '',
      created: 1628831743,
      read: false,
      importance: 'high',
      messageType: 'みんでん',
    ),
    Message(
      messageId: 2,
      userId: 'userId',
      plantId: 'plantId',
      title: 'title',
      body:
          '今後も地域社会の一員として、地域の皆様とコミュニケーションをとることで良い関係を築き、地域に愛される発電所であり続けるよう努めていきます。最大文字数110文字程度（仮）テキストテキストテキ',
      image: '',
      created: 1628831743,
      read: false,
      importance: 'high',
      messageType: 'みんでん',
    ),
    Message(
      messageId: 3,
      userId: 'userId',
      plantId: 'plantId',
      title: 'title',
      body:
          '今後も地域社会の一員として、地域の皆様とコミュニケーションをとることで良い関係を築き、地域に愛される発電所であり続けるよう努めていきます。最大文字数110文字程度（仮）テキストテキストテキ',
      image:
          'https://images.unsplash.com/photo-1631505786347-806c1710e932?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2201&q=80',
      created: 1628831743,
      read: true,
      importance: 'high',
      messageType: '発電所',
    ),
    Message(
      messageId: 4,
      userId: 'userId',
      plantId: 'plantId',
      title: 'title',
      body:
          '今月の応援先発電所が確定しました。\n応援先発電所はマイページから確認できます。\n引き続き、みんな電力の\n 「顔の見える電力」をお楽しみください！',
      image:
          'https://images.unsplash.com/photo-1631490238089-0e2ca174a876?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
      created: 1628831743,
      read: true,
      importance: 'high',
      messageType: '発電所',
    )
  ],
);
