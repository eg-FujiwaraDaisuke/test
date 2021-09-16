import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/support_participant/domain/entities/participant.dart';

class SupportParticipantsDialog {
  SupportParticipantsDialog({required this.context, required this.participants})
      : super();

  final BuildContext context;
  final List<Participant> participants;
  void showDialog() {
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
                            text: participants.length.toString(),
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
                    Container(
                      width: 286,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 7,
                        runSpacing: 16,
                        children: participants
                            .map(
                              _buildPartcipantItem,
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
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
                              context, 'support_participants_support_from_web'),
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
                                // ここにWEBから応援している人数が入る
                                text: '7',
                                style: const TextStyle(
                                  color: Color(0xFFFF8C00),
                                  fontSize: 14,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: i18nTranslate(
                                    context, 'support_participants_people'),
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
      ),
    );
  }

  Widget _buildPartcipantItem(Participant participant) {
    return GestureDetector(
      onTap: () {
        print(participant.name);
      },
      child: Column(
        children: [
          Container(
            width: 47,
            height: 47,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              participant.icon,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 66,
            child: Text(
              participant.name,
              textAlign: TextAlign.center,
              style: TextStyle(
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
