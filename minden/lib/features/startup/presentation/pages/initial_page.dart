import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/localize/presentation/bloc/localized_bloc.dart';
import 'package:minden/features/localize/presentation/bloc/localized_event.dart';
import 'package:minden/features/localize/presentation/bloc/localized_state.dart';
import 'package:minden/features/startup/data/datasources/startup_info_datasource.dart';
import 'package:minden/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:minden/features/startup/domain/usecases/get_startup_info.dart';
import 'package:minden/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:minden/features/startup/presentation/bloc/startup_event.dart';
import 'package:minden/features/startup/presentation/bloc/startup_state.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> with AfterLayoutMixin {
  StreamSubscription _subscription;
  final _bloc = StartupBloc(
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
    BlocProvider.of<LocalizedBloc>(context).stream.listen((state) async {
      if (state is LocalizedStateLoaded) {
        await FlutterI18n.refresh(context, Locale(state.info.languageCode));
        BlocProvider.of<LocalizedBloc>(context)
            .add(UpdateLocalizedInfoEvent(state.info.languageCode));
      } else if (state is LocalizedStateUpdated) {
        // localizeの取得設定の後、remote configの読み込みを行う。
        _bloc.add(GetStartupInfoEvent());
      } else if (state is LocalizedStateError) {
        await FlutterI18n.refresh(context, Locale("ja"));
        BlocProvider.of<LocalizedBloc>(context)
            .add(UpdateLocalizedInfoEvent("ja"));
      }
    });

    _subscription = _bloc.stream.listen((state) {
      if (state is StartupStateLoading) {
        BotToast.showCustomLoading(
            toastBuilder: (_) => CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor)));
        return;
      }

      // support versionエラーアラート / メンテ中アラート
      if (state is StartupStateError) {
        (() async {
          await _showAlert(
              message: i18nTranslate(context, state.localizedKey, state.args),
              actionName: i18nTranslate(context, state.actionKey),
              actionUrl: state.actionUrl,
              barrierDismissible: false);
          _bloc.add(GetStartupInfoEvent());
        })();
        return;
      }
      if (state is StartupStateLoaded) {
        if (state.info.hasLatestVersion) {
          (() async {
            await _showAlert(
                message: i18nTranslate(context, "latest_version_message_%s",
                    [state.info.latestVersion]),
                actionName: i18nTranslate(context, "store_action"),
                actionUrl: state.info.storeUrl,
                barrierDismissible: true);
          })();
        }
      }
      BotToast.closeAllLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _bloc,
        child: Container(),
      ),
    );
  }

  Future<void> _showAlert(
      {String message,
      String actionName,
      String actionUrl,
      bool barrierDismissible}) async {
    if (barrierDismissible) {
      final result = await showDialog<bool>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (_) {
            return _alertWidget(message, actionName);
          });
      if (result != null) {
        if (actionUrl?.isNotEmpty ?? false) {
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
    if (result) {
      if (actionUrl?.isNotEmpty ?? false) {
        await launch(actionUrl);
      }
    }
  }

  Widget _alertWidget(String message, String actionName) {
    return AlertDialog(
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(actionName),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final osLocale = Localizations.localeOf(context);
    BlocProvider.of<LocalizedBloc>(context)
        .add(GetLocalizedInfoEvent(osLocale.languageCode));
  }
}
