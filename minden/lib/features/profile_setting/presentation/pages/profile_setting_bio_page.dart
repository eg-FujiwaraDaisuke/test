import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_tags_page.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';

class ProfileSettingBioPage extends StatefulWidget {
  @override
  _ProfileSettingBioPageState createState() => _ProfileSettingBioPageState();
}

class _ProfileSettingBioPageState extends State<ProfileSettingBioPage> {
  String _inputBio = '';
  late UpdateProfileBloc _updateProfileBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _updateProfileBloc = UpdateProfileBloc(
      const ProfileStateInitial(),
      UpdateProfile(
        ProfileRepositoryImpl(
          dataSource: ProfileDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _updateProfileBloc.stream.listen((event) {
      if (event is ProfileLoading) {
        Loading.show(context);
        return;
      }
      Loading.hide();
      if (event is ProfileLoaded) {
        final route = MaterialPageRoute(
          builder: (context) => ProfileSettingTagsPage(
            isRouteToPop: false,
          ),
          settings: const RouteSettings(name: '/profileSetting/tag'),
        );
        Navigator.push(context, route);
      }
    });
  }

  @override
  void dispose() {
    _updateProfileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: _prev,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/common/leading_back.svg',
              fit: BoxFit.fill,
              width: 44,
              height: 44,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 38),
                Text(
                  i18nTranslate(context, 'profile_setting_bio'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF787877),
                  ),
                ),
                const SizedBox(height: 38),
                _BioInput(
                    formKey: _formKey,
                    onSaved: (value) {
                      _inputBio = value;
                    }),
                const SizedBox(height: 126),
                Button(
                  onTap: _next,
                  text: i18nTranslate(context, 'to_next'),
                  size: ButtonSize.S,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _updateProfileBloc.add(
        UpdateProfileEvent(
          name: '',
          icon: '',
          bio: _inputBio,
          wallPaper: '',
          freeLink: '',
          twitterLink: '',
          facebookLink: '',
          instagramLink: '',
        ),
      );
    }
  }

  void _prev() {
    Navigator.pop(context);
  }
}

class _BioInput extends StatefulWidget {
  const _BioInput({
    required this.formKey,
    required this.onSaved,
  });

  final GlobalKey formKey;
  final Function onSaved;

  @override
  _BioInputState createState() => _BioInputState();
}

class _BioInputState extends State<_BioInput> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        height: 110,
        width: 339,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onSaved: (value) => widget.onSaved(value),
          style: const TextStyle(
            color: Color(0xFF7C7C7C),
            fontSize: 18,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
