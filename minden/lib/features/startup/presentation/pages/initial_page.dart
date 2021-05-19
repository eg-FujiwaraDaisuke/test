import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/features/startup/data/datasources/maintenance_info_datasource.dart';
import 'package:minden/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:minden/features/startup/domain/usecases/get_maintenance_info.dart';
import 'package:minden/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:minden/features/startup/presentation/bloc/startup_event.dart';
import 'package:minden/features/startup/presentation/bloc/startup_state.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  StreamSubscription _subscription;
  final _bloc = StartupBloc(
    StartupStateEmpty(),
    GetMaintenanceInfo(
      StartupRepositoryImpl(
        dataSource: MaintenanceInfoDataSourceImpl(),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _bloc.add(GetMaintenanceInfoEvent());
    _subscription = _bloc.stream.listen((state) {
      if (state is StartupStateLoading) {
        BotToast.showCustomLoading(
            toastBuilder: (_) => CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor)));
        return;
      }

      if (state is StartupStateLoaded) {
        if (state.info.underMaintenance) {
          (() async {
            final result = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      content: Text(state.info.maintenanceDescription),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );
                });
            if (result) {
              // メンテナンス中は取得したURLをブラウザで開く。
              _bloc.add(GetMaintenanceInfoEvent());
              await launch(state.info.maintenanceUrl);
            }
          })();
          return;
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

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
