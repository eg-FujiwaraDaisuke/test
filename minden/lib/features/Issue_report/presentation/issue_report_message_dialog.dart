import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/Issue_report/data/datasources/issue_report_datasource.dart';
import 'package:minden/features/Issue_report/data/repositories/issue_report_repository_impl.dart';
import 'package:minden/features/Issue_report/domain/usecases/issue_report_usecase.dart';
import 'package:minden/features/Issue_report/presentation/bloc/issue_report_bloc.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/utile.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../injection_container.dart';

class IssueReportMessageDialog {
  IssueReportMessageDialog({
    required this.context,
    required this.targetUserId,
  }) : super();

  late String reportText = '';
  late bool isInappropriate = false;
  late bool isSelfHarm = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String targetUserId;
  final BuildContext context;

  final _sendIssueReportBloc = SendIssueReportBloc(
    const IssueReportInit(),
    SendIssueReport(
      IssueReportRepositoryImpl(
        dataSource: IssueReportDataSourceImpl(
          client: http.Client(),
        ),
      ),
    ),
  );

  Future<bool?> showDialog() async {
    _sendIssueReportBloc.stream.listen((event) async {
      if (event is IssueReportSending) {
        Loading.show(context);
        return;
      }
      Loading.hide();
      if (event is IssueReportSended) {
        await _sendIssueReportBloc.close();
        Navigator.pop(context, true);
        return;
      }
      if (event is IssueReportError) {
        if (event.needLogin) {
          await _sendIssueReportBloc.close();
          BlocProvider.of<LogoutBloc>(context).add(LogoutEvent());
          await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
            (_) => false,
          );
        }
      }
    });

    return Navigator.push(
      context,
      CustomDialogOverlay(
        StatefulBuilder(builder: (context, setState) {
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
                        activeColor: const Color(0xFF7D7E7F),
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
                        activeColor: const Color(0xFF7D7E7F),
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
                        value: isSelfHarm,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isSelfHarm = newValue!;
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
                            onChanged: (value) {
                              setState(() {
                                reportText = value;
                              });
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
                          GestureDetector(
                            onTap: () async {
                              await launch(
                                  'https://minden.co.jp/personal/terms-of-service');
                            },
                            child: Text(
                              i18nTranslate(context, 'violate_rules_here'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.lightGreen[200],
                                fontSize: 13,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // 通報の具体的な内容が書かれていない場合通報できない
                      if (reportText != '')
                        Button(
                          onTap: () async {
                            final List<int> issueType = [];
                            if (isSelfHarm) issueType.add(1);
                            if (isInappropriate) issueType.add(2);

                            final userJsonData =
                                await si<EncryptionTokenDataSourceImpl>()
                                    .restoreUser();
                            final userJson = json.decode(userJsonData);
                            final user = User.fromJson(userJson);

                            _sendIssueReportBloc.add(SendIssueReportEvent(
                              userId: user.profile.userId!,
                              targetUserId: targetUserId,
                              issueType: issueType,
                              message: reportText,
                            ));
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
}
