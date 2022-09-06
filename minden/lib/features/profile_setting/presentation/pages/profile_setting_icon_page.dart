import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/image_picker_bottom_sheet/image_picker_bottom_sheet.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_bio_page.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_bloc.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_event.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_state.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/gen/assets.gen.dart';

class ProfileSettingIconPage extends StatefulWidget {
  @override
  _ProfileSettingIconPageState createState() => _ProfileSettingIconPageState();
}

class _ProfileSettingIconPageState extends State<ProfileSettingIconPage> {
  late UpdateProfileBloc _updateProfileBloc;

  void _setImage(File croppedImage) {
    BlocProvider.of<UploadBloc>(context).add(UploadMediaEvent(croppedImage));
  }

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
              Assets.images.common.leadingBack,
              fit: BoxFit.fill,
              width: 44,
              height: 44,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _next,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  i18nTranslate(context, 'skip_katakana'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is Uploading) {
            Loading.show(context);
            return;
          }
          Loading.hide();
          if (state is Uploaded) {
            _updateProfileBloc.add(
              UpdateProfileEvent(
                name: '',
                icon: state.media.url,
                bio: '',
                wallPaper: '',
                freeLink: '',
                twitterLink: '',
                facebookLink: '',
                instagramLink: '',
              ),
            );
          }
        },
        child: BlocBuilder<UploadBloc, UploadState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 38),
                      Text(
                        i18nTranslate(context, 'profile_setting_icon'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF787877),
                        ),
                      ),
                      const SizedBox(height: 38),
                      GestureDetector(
                        onTap: () {
                          ImagePickerBottomSheet.show(
                              context: context,
                              imageHandler: _setImage,
                              cropStyle: CropStyle.circle);
                        },
                        child: _buildImage(state),
                      ),
                      const SizedBox(height: 182),
                      Button(
                        onTap: _next,
                        text: i18nTranslate(context, 'to_next'),
                        size: ButtonSize.S,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _next() {
    final route = MaterialPageRoute(
      builder: (context) => ProfileSettingBioPage(),
      settings: const RouteSettings(name: '/profileSetting/bio'),
    );
    Navigator.push(context, route);
  }

  void _prev() {
    Navigator.pop(context);
  }

  Widget _buildImage(UploadState state) {
    if (state is Uploaded) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(state.media.url),
          ),
        ),
      );
    }
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          Assets.images.common.camera,
          width: 32,
          height: 28,
        ),
      ),
    );
  }
}
