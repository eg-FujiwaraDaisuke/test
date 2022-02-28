import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';

/// 発電所応援ダイアログ
class SupportParticipantsDialog {
  SupportParticipantsDialog({
    required this.context,
    required this.participants,
  }) : super();

  static const String routeName = '/home/top/detail/supportParticipants';

  final BuildContext context;
  final PowerPlantParticipant participants;

  void showDialog() {
    final fromWebSupporters =
        participants.participantSize - participants.userList.length;
    Navigator.push(
      context,
      CustomDialogOverlay(
        Stack(
          children: [
            Positioned(
              child: Container(
                width: 338,
                padding: const EdgeInsets.only(top: 50, bottom: 31),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: i18nTranslate(context, 'now'),
                            style: const TextStyle(
                              color: Color(0xFF787877),
                              fontSize: 16,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${participants.participantSize.toString()}${i18nTranslate(context, 'support_participants_people')}',
                            style: const TextStyle(
                              color: Color(0xFF787877),
                              fontSize: 16,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: i18nTranslate(
                                context, 'support_participants_supporting'),
                            style: const TextStyle(
                              color: Color(0xFF787877),
                              fontSize: 16,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 27,
                    ),
                    SizedBox(
                      width: 286,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 7,
                        runSpacing: 16,
                        children: participants.userList
                            .map(
                              _buildParticipantItem,
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    if (fromWebSupporters > 0) ...[
                      Container(
                        color: const Color(0xFFDADADA),
                        width: 287,
                        height: 1,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            i18nTranslate(
                              context,
                              'support_participants_support_from_web',
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFF8C00),
                              fontSize: 14,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 29,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${fromWebSupporters}',
                                  style: const TextStyle(
                                    color: Color(0xFFFF8C00),
                                    fontSize: 14,
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: i18nTranslate(
                                    context,
                                    'support_participants_people',
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFFFF8C00),
                                    fontSize: 14,
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              top: 25,
              right: 27,
              child: GestureDetector(
                onTap: _hideDialog,
                child: Icon(Icons.close),
              ),
            ),
          ],
        ),
        isAndroidBackEnable: false,
        settings: const RouteSettings(name: routeName),
      ),
    );
  }

  Widget _buildParticipantItem(PowerPlantParticipantUser participant) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        final route = MaterialPageRoute(
          builder: (context) => ProfilePage(
            userId: participant.userId,
          ),
          settings: const RouteSettings(name: '/user/profile'),
        );
        Navigator.push(context, route);
      },
      child: Column(
        children: [
          Container(
            width: 47,
            height: 47,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: participant.icon == null
                  ? Image.asset(
                      'assets/images/user/icon_no_photo.png',
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: participant.icon,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Image.asset(
                          'assets/images/user/icon_no_photo.png',
                          fit: BoxFit.cover,
                        );
                      },
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/common/noimage.png',
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 66,
            child: Text(
              participant.name ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFF8C00),
                fontSize: 11,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  /*
   * 非表示
   */
  void _hideDialog() {
    Navigator.of(context).pop();
  }
}
