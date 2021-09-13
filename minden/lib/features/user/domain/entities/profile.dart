import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.userId,
    required this.name,
    required this.icon,
    required this.bio,
    required this.wallPaper,
    required this.tags,
  });

  factory Profile.fromJson(Map<String, dynamic> elem) {
    print('Profile.fromJson');
    final List<Tag> tags = elem['tags']?.map<Tag>((e) {
          return Tag.fromJson(e);
        }).toList() ??
        [];
    return Profile(
        userId: elem['userId'],
        name: elem['name'],
        icon: elem['icon'],
        bio: elem['bio'],
        wallPaper: elem['wallPaper'],
        tags: tags);
  }

  final String? userId;
  final String name;
  final String icon;
  final String bio;
  final String wallPaper;
  final List<Tag> tags;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'icon': icon,
      'bio': bio,
      'wallPaper': wallPaper,
      'tags': tags.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object?> get props => [userId];
}

class Tag extends Equatable {
  const Tag({
    required this.tagId,
    required this.tagName,
  });

  factory Tag.fromJson(Map<String, dynamic> tag) {
    return Tag(
      tagId: tag['tagId'],
      tagName: tag['tagName'],
    );
  }

  final int tagId;
  final String tagName;

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'tagName': tagName,
    };
  }

  @override
  List<Object> get props => [tagId];
}
