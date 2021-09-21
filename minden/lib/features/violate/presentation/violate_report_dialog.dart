import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/utile.dart';

class ViolateReportDialog {
  ViolateReportDialog({
    required this.context,
  }) : super();

  late String reportText = '';
  late bool isInappropriate = false;
  late bool isSelfInjury = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final BuildContext context;
  Future<bool?> showDialog() async {
    return Navigator.push(
      context,
      CustomDialogOverlay(
        StatefulBuilder(builder: (
          context,
          setState,
        ) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  width: 338,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        i18nTranslate(context, 'report'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF575292),
                          fontSize: 18,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      Container(
                        width: 336,
                        height: 1,
                        color: const Color(0xFFE2E2E2),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      SizedBox(
                        width: 289,
                        child: Text(
                          i18nTranslate(context, 'violate_reason'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: const Color(0xFF575292),
                            fontSize: 15,
                            height:
                                calcFontHeight(fontSize: 15, lineHeight: 18),
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: Color(0xFF7D7E7F),
                        title: Text(
                          i18nTranslate(context, 'violate_inappropriate'),
                          style: const TextStyle(
                            color: Color(0xFF575292),
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isInappropriate,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isInappropriate = newValue!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: Color(0xFF7D7E7F),
                        title: Text(
                          i18nTranslate(context, 'violate_self_injury'),
                          style: const TextStyle(
                            color: Color(0xFF575292),
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: isSelfInjury,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isSelfInjury = newValue!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      Text(
                        i18nTranslate(context, 'violate_specifics'),
                        style: const TextStyle(
                          color: Color(0xFF575292),
                          fontSize: 18,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          width: 296,
                          height: 81,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            maxLines: null,
                            minLines: 3,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF787877),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF787877),
                                ),
                              ),
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              if (value != null) {
                                setState(() {
                                  reportText = value;
                                });
                              }
                            },
                            style: TextStyle(
                              color: const Color(0xFFA7A7A7),
                              fontSize: 13,
                              height:
                                  calcFontHeight(fontSize: 13, lineHeight: 18),
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            i18nTranslate(context, 'violate_rules'),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF575292),
                              fontSize: 13,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            i18nTranslate(context, 'violate_rules_here'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.lightGreen[200],
                              fontSize: 13,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      if (isInappropriate || isSelfInjury)
                        Button(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          text: i18nTranslate(context, 'reporting'),
                          size: ButtonSize.S,
                        )
                      else
                        Button(
                          onTap: () {},
                          isActive: false,
                          text: i18nTranslate(context, 'reporting'),
                          size: ButtonSize.S,
                        ),
                      TextButton(
                        onPressed: () {
                          // TODO ここでAPIを叩く
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          i18nTranslate(context, 'cancel_katakana'),
                          style: const TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 61,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
        isAndroidBackEnable: false,
      ),
    );
  }

  void _hideDialog() {
    Navigator.of(context).pop();
  }
}
