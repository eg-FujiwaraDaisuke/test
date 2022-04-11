import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';

/// 応援ユーザー表示
class ParticipantUserIconGroup extends StatelessWidget {
  const ParticipantUserIconGroup({
    Key? key,
    required this.participantUserList,
    required this.participantSize,
    required this.maxUserIconCount,
    required this.iconSize,
    required this.overlapLength,
  }) : super(key: key);

  final List<PowerPlantParticipantUser> participantUserList;

  final int participantSize;

  /// 表示可能な最大ユーザーアイコン数
  final int maxUserIconCount;

  /// アイコンサイズ（直径）
  final double iconSize;

  /// アイコン同士の重なり度合い
  final double overlapLength;

  @override
  Widget build(BuildContext context) {
    return _generateParticipant();
  }

  Widget _generateParticipant() {
    // 後ろのアイコンから先に表示するので、リストをリバースさせている
    final icons = _generateParticipantIcons().reversed.toList();
    if (icons.isEmpty) return Container();
    return Stack(
      children: List.generate(
        icons.length,
        (index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                (maxUserIconCount - index) * overlapLength, 0, 0, 0),
            child: icons[index],
          );
        },
      ),
    );
  }

  List<Widget> _generateParticipantIcons() {
    final total = participantSize;
    if (maxUserIconCount < total) {
      // 規定数人以上応援ユーザーがいる場合、
      return [
        ...participantUserList
            .take(maxUserIconCount)
            .map((p) => _generateCircleUserIcon(p.icon))
            .toList(),
        _generateCircleRemainIcon(total),
      ];
    } else {
      // 規定数人以下の応援ユーザーしかいないため、「+X」表記を行わない
      return participantUserList
          .map((p) => _generateCircleUserIcon(p.icon))
          .toList();
    }
  }

  Widget _generateCircleUserIcon(String? imageUrl) {
    final valid = Uri.parse(imageUrl ?? '').isAbsolute;
    return Container(
      width: iconSize,
      height: iconSize,
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(iconSize / 2),
      ),
      // 魔法の padding
      padding: const EdgeInsets.all(0.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(iconSize / 2),
        child: valid
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                placeholder: (context, url) {
                  return Image.asset(
                    'assets/images/user/icon_no_photo.png',
                    fit: BoxFit.cover,
                  );
                },
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/user/icon_no_photo.png',
                  fit: BoxFit.cover,
                ),
                width: iconSize,
                height: iconSize,
              )
            : Image.asset(
                'assets/images/user/icon_no_photo.png',
                fit: BoxFit.cover,
                width: iconSize,
                height: iconSize,
              ),
      ),
    );
  }

  Widget _generateCircleRemainIcon(int participantCount) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(iconSize / 2),
      child: Container(
        width: iconSize,
        height: iconSize,
        alignment: Alignment.center,
        color: const Color(0xFFEDCB50),
        padding: const EdgeInsets.only(left: 4),
        child: Text('+${participantCount - maxUserIconCount}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.2,
            )),
      ),
    );
  }
}
