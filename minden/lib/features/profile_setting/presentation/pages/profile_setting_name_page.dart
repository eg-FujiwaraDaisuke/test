import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_icon_page.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/usecases/update_profile.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';

class ProfileSettingNamePage extends StatefulWidget {
  @override
  _ProfileSettingNamePageState createState() => _ProfileSettingNamePageState();
}

class _ProfileSettingNamePageState extends State<ProfileSettingNamePage> {
  String _inputName = '';
  late UpdateProfileBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = UpdateProfileBloc(
      const ProfileStateInitial(),
      UpdateProfile(
        ProfileRepositoryImpl(
          dataSource: ProfileDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _bloc.stream.listen((event) {
      if (event is ProfileUpdating) {
        Loading.show(context);
        return;
      }
      Loading.hide();
      if (event is ProfileUpdated) {
        final route = MaterialPageRoute(
          builder: (context) => ProfileSettingIconPage(),
          settings: RouteSettings(name: "/profileSetting/icon"),
        );
        Navigator.push(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 38),
                Text(
                  i18nTranslate(context, 'profile_setting_input_name'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF787877),
                  ),
                ),
                const SizedBox(height: 38),
                _NameInput(onChanged: (value) {
                  _inputName = value;
                }),
                const SizedBox(height: 182),
                Botton(
                  onTap: _next,
                  text: i18nTranslate(context, 'profile_setting_next'),
                  size: BottonSize.S,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _next() {
    _bloc.add(
      UpdateProfileInfo(
        name: _inputName,
        icon: '',
        bio: '',
        wallPaper: '',
      ),
    );
  }
}

class _NameInput extends StatefulWidget {
  final Function onChanged;

  const _NameInput({
    required this.onChanged,
  }) : super();

  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 339,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            onChanged: (value) {
              widget.onChanged(value);
            },
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 15,
              ),
            ),
            style: const TextStyle(
              fontSize: 17.0,
              color: Color(0xFF000000),
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
