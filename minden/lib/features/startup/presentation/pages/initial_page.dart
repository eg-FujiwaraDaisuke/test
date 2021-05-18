import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minden/features/startup/presentation/bloc/startup_bloc.dart';
import 'package:minden/features/startup/presentation/bloc/startup_event.dart';
import 'package:minden/features/startup/presentation/bloc/startup_state.dart';

import '../../data/datasources/maintenance_info_datasource.dart';
import '../../data/repositories/startup_repository_impl.dart';
import '../../domain/usecases/get_maintenance_info.dart';

class InitialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _bloc = StartupBloc(
    Empty(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heee Haaa'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<StartupBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              BlocBuilder<StartupBloc, StartupState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return Container();
                  } else if (state is Loading) {
                    return Container();
                  } else if (state is Loaded) {
                    return Column(children: [
                      Text(state.info.maintenanceUrl),
                    ]);
                  } else if (state is Error) {
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
