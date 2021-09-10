import 'package:flutter/material.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/support_plant/domain/entities/participant.dart';

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
                    const Text(
                      //TODO ここに応援中の人数が入ります。
                      '現在16人が応援しています！',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF787877),
                        fontSize: 16,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w400,
                      ),
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
                              (participant) =>
                                  _buildPartcipantItem(participant),
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
                          'WEBから応援している人',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFF8C00),
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 29,
                        ),
                        Text(
                          //TODO ここに応援中の人数が入ります。
                          '7人',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFF8C00),
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w500,
                          ),
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
                child: Icon(Icons.close),
                onTap: _hideDialog,
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
