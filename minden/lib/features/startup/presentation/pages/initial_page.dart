import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/home/presentation/pages/home_page.dart';
import 'package:minden/features/localize/presentation/bloc/localized_bloc.dart';
import 'package:minden/features/localize/presentation/bloc/localized_event.dart';
import 'package:minden/features/localize/presentation/bloc/localized_state.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_name_page.dart';
import 'package:minden/features/startup/data/datasources/startup_info_datasource.dart';
import 'package:minden/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:minden/features/startup/domain/usecases/startup_usecase.dart';
import 'package:minden/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:minden/features/startup/presentation/bloc/startup_event.dart';
import 'package:minden/features/startup/presentation/bloc/startup_state.dart';
import 'package:minden/features/startup/presentation/pages/tutorial_page.dart';
import 'package:minden/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> with AfterLayoutMixin {
  final _startupBloc = StartupBloc(
    StartupStateEmpty(),
    GetStartupInfo(
      StartupRepositoryImpl(
        dataSource: StartupInfoDataSourceImpl(),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    // ローカライズの初期化
    StreamSubscription? localizedSubscription;
    localizedSubscription =
        BlocProvider.of<LocalizedBloc>(context).stream.listen((state) async {
      if (state is LocalizedStateLoaded) {
        await FlutterI18n.refresh(context, Locale(state.info.languageCode));
        BlocProvider.of<LocalizedBloc>(context)
            .add(UpdateLocalizedInfoEvent(state.info.languageCode));
      } else if (state is LocalizedStateUpdated) {
        localizedSubscription?.cancel();
        // localizeの取得設定の後、remote configの読み込みを行う。
        _startupBloc.add(GetStartupInfoEvent());
      } else if (state is LocalizedStateError) {
        await FlutterI18n.refresh(context, const Locale('ja'));
        BlocProvider.of<LocalizedBloc>(context)
            .add(UpdateLocalizedInfoEvent('ja'));
      }
    });

    StreamSubscription? startupSubscription;
    startupSubscription = _startupBloc.stream.listen((state) {
      if (state is StartupStateLoading) {
        Loading.show(context);
        return;
      }
      Loading.hide();

      // support versionエラーアラート / メンテ中アラート
      if (state is StartupStateError) {
        (() async {
          await _showAlert(
              message: i18nTranslate(context, state.localizedKey, state.args),
              actionName: i18nTranslate(context, state.actionKey),
              actionUrl: state.actionUrl ?? '',
              barrierDismissible: false);
          _startupBloc.add(GetStartupInfoEvent());
        })();
        return;
      }

      if (state is StartupStateLoaded) {
        if (state.info.hasLatestVersion) {
          (() async {
            await _showAlert(
                message: i18nTranslate(context, 'latest_version_message_%s',
                    [state.info.latestVersion]),
                actionName: i18nTranslate(context, 'store_action'),
                actionUrl: state.info.storeUrl,
                barrierDismissible: true);

            startupSubscription?.cancel();
            _nextPage(state.info.hasTutorial);
          })();
          return;
        }

        startupSubscription?.cancel();
        _nextPage(state.info.hasTutorial);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF8C00),
      body: BlocProvider.value(
        value: _startupBloc,
        child: Center(
          child: SvgPicture.asset(
            'assets/images/login/title.svg',
            width: 212,
            height: 60,
          ),
        ),
      ),
    );
  }

  Future<void> _showAlert(
      {required String message,
      required String actionName,
      required String actionUrl,
      required bool barrierDismissible}) async {
    if (barrierDismissible) {
      final result = await showDialog<bool>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (_) {
            return _alertWidget(message, actionName);
          });
      if (result != null) {
        if (actionUrl.isNotEmpty) {
          await launch(actionUrl);
        }
      }
      return;
    }

    final result = await showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async => false,
            child: _alertWidget(message, actionName),
          );
        });
    if (result != null) {
      if (actionUrl.isNotEmpty) {
        await launch(actionUrl);
      }
    }
  }

  Widget _alertWidget(String message, String actionName) {
    return AlertDialog(
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(actionName),
        ),
      ],
    );
  }

  void _nextPage(bool hasTutorial) {
    // 新規ユーザー
    if (!hasTutorial) {
      final route = NoAnimationMaterialPageRoute(
        builder: (context) => TutorialPage(),
        settings: const RouteSettings(name: TutorialPage.routeName),
      );
      Navigator.pushReplacement(context, route);
      return;
    }

    si<Account>().prepare().then((value) async {
      if (si<Account>().appToken?.isEmpty ?? true) {
        // チュートリアルはみたが、ログインしないユーザー
        Navigator.pushReplacement(context, LoginPage.route());
        return;
      }

      final sharedPreferences = await SharedPreferences.getInstance();
      final hasProfile = sharedPreferences.getBool('has_profile') ?? false;
      if (!hasProfile) {
        Navigator.pushReplacement(context, ProfileSettingNamePage.route());
        return;
      }

      // ログインしてて、チュートリアルもみたユーザー
      Navigator.pushReplacement(context, HomePage.route());
    });
  }

  @override
  void dispose() {
    _startupBloc.close();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final locale = Localizations.localeOf(context);
    BlocProvider.of<LocalizedBloc>(context)
        .add(GetLocalizedInfoEvent(locale.languageCode));
  }
}
