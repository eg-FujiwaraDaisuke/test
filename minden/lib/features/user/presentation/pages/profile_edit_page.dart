import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/image_picker_bottom_sheet/image_picker_bottom_sheet.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_bloc.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_event.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_state.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_painter.dart';

import '../../../../injection_container.dart';
import '../../../../utile.dart';

enum UploadItem {
  icon,
  wallPaper,
  none,
}

class ProfileEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileEditPageState();
  }
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // 確認用仮データ
  final data = ProfileDamyData().damyData;
  late UpdateProfileBloc _updateBloc;
  late GetProfileBloc _getBloc;

  late String _wallPaperUrl;
  late String _iconUrl;
  late String _name;
  late String _bio;

  @override
  void initState() {
    super.initState();

    _name = '';
    _bio = '';
    _wallPaperUrl = '';
    _iconUrl = '';

    _getBloc = GetProfileBloc(
      const ProfileStateInitial(),
      GetProfile(
        ProfileRepositoryImpl(
          dataSource: ProfileDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _updateBloc = UpdateProfileBloc(
      const ProfileStateInitial(),
      UpdateProfile(
        ProfileRepositoryImpl(
          dataSource: ProfileDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );
    _updateBloc.stream.listen((event) {
      if (event is ProfileLoading) {
        Loading.show(context);
        return;
      }
      Loading.hide();
    });

    _getBloc.add(GetProfileEvent(userId: si<Account>().userId));
  }

  @override
  void dispose() {
    _updateBloc.close();
    _getBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _getBloc,
      child: BlocListener<GetProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();
        },
        child: BlocBuilder<GetProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadError) {
              return Scaffold(
                backgroundColor: const Color(0xFFF6F5EF),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: GestureDetector(
                    onTap: () {
                      _prev(context);
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/common/leading_back.svg',
                        fit: BoxFit.fill,
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () => _complete(context),
                      child: Container(
                        width: 90,
                        height: 44,
                        margin:
                            const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/user/check.svg'),
                            const SizedBox(
                              width: 10.5,
                            ),
                            Text(
                              i18nTranslate(context, 'user_edit_complete'),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                extendBodyBehindAppBar: true,
                body: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              _ProfileWallPaperEdit(
                                imageHandler: (value) {
                                  _wallPaperUrl = value;
                                },
                              ),
                              Positioned(
                                child: _ProfileIconEdit(
                                  imageHandler: (value) {
                                    _iconUrl = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 63,
                          ),
                          const _ProfileNameEditForm(
                            name: '',
                          ),
                          const SizedBox(
                            height: 33,
                          ),
                          const _ProfileBioEditForm(
                            bio: '',
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const _ImportantTagsList(
                            tagsList: [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return PlaceHolderProfile();
          },
        ),
      ),
    );
  }

  bool _isDirty() {
    return _iconUrl.isNotEmpty ||
        _wallPaperUrl.isNotEmpty ||
        _name.isNotEmpty ||
        _bio.isNotEmpty;
  }

  Future<void> _prev(BuildContext context) async {
    if (!_isDirty()) {
      Navigator.pop(context, false);
      return;
    }

    final isDiscard = await showDialog(
      context: context,
      builder: (context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title:
                    Text(i18nTranslate(context, 'profile_edit_alert_discard')),
                content: Text(i18nTranslate(
                    context, 'profile_edit_alert_discard_confirm')),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(i18nTranslate(context, 'cancel_katakana')),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(i18nTranslate(context, 'discard')),
                  ),
                ],
              )
            : AlertDialog(
                title:
                    Text(i18nTranslate(context, 'profile_edit_alert_discard')),
                content: Text(i18nTranslate(
                    context, 'profile_edit_alert_discard_confirm')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(i18nTranslate(context, 'cancel_katakana')),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(i18nTranslate(context, 'discard')),
                  ),
                ],
              );
      },
    );

    if (isDiscard) {
      Navigator.pop(context, false);
    }
  }

  void _complete(BuildContext context) {
    Navigator.pop(context, true);
  }
}

class _ProfileWallPaperEdit extends StatefulWidget {
  _ProfileWallPaperEdit({required this.imageHandler});

  final Function(String url) imageHandler;

  @override
  _ProfileWallPaperEditState createState() => _ProfileWallPaperEditState();
}

class _ProfileWallPaperEditState extends State<_ProfileWallPaperEdit> {
  ui.Image? _uiImage;
  bool _queuing = false;

  @override
  void initState() {
    super.initState();
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) async {
        if (!_queuing) {
          return;
        }
        if (state is Uploading) {
          Loading.show(context);
          return;
        }
        Loading.hide();
        if (state is Uploaded) {
          if (_queuing) {
            _queuing = false;
            final imageData =
                await NetworkAssetBundle(Uri.parse(state.media.url)).load('');
            final bytes = imageData.buffer.asUint8List();
            _uiImage = await loadImage(bytes);
            widget.imageHandler(state.media.url);
            setState(() {});
          }
        }
      },
      child: BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          final stack = Stack(
            children: [
              Column(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 168),
                    painter: WallPaperPainter(wallPaperImage: _uiImage),
                  ),
                  Container(
                    height: 44,
                  ),
                ],
              ),
              Positioned(
                bottom: 70,
                right: 55,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ImagePickerBottomSheet.show(
                        context: context,
                        imageHandler: (value) {
                          _queuing = true;
                          BlocProvider.of<UploadBloc>(context)
                              .add(UploadMediaEvent(value));
                        },
                        cropStyle: CropStyle.circle);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/user/camera.svg',
                        width: 15,
                        height: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
          return stack;
        },
      ),
    );
  }
}

class _ProfileIconEdit extends StatefulWidget {
  _ProfileIconEdit({required this.imageHandler});

  final Function(String url) imageHandler;

  @override
  _ProfileIconEditState createState() => _ProfileIconEditState();
}

class _ProfileIconEditState extends State<_ProfileIconEdit> {
  bool _queuing = false;
  String _url = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) async {
        if (!_queuing) {
          return;
        }
        if (state is Uploading) {
          Loading.show(context);
          return;
        }
        Loading.hide();
      },
      child: BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          if (state is Uploaded) {
            if (_queuing) {
              _queuing = false;
              _url = state.media.url;
              widget.imageHandler(state.media.url);
            }
          }
          return Stack(
            children: [
              Positioned(
                child: Container(
                  width: 99,
                  height: 99,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF8C00),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 93,
                      height: 93,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFB92),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: Colors.white,
                        ),
                        image: _url.isEmpty
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_url),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    ImagePickerBottomSheet.show(
                        context: context,
                        imageHandler: (value) {
                          _queuing = true;
                          BlocProvider.of<UploadBloc>(context)
                              .add(UploadMediaEvent(value));
                        },
                        cropStyle: CropStyle.circle);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFB92),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/user/camera.svg',
                        width: 15,
                        height: 14,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _ProfileNameEditForm extends StatelessWidget {
  const _ProfileNameEditForm({
    required this.name,
  }) : super();
  final String name;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 54,
            width: 339,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 18,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBioEditForm extends StatelessWidget {
  const _ProfileBioEditForm({required this.bio}) : super();
  final bio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18nTranslate(context, 'profile_edit_self_intro'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Form(
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
              initialValue: bio,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: const Color(0xFF7C7C7C),
                fontSize: 12,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w400,
                letterSpacing: calcLetterSpacing(letter: 0.5),
                height: calcFontHeight(lineHeight: 22.08, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImportantTagsList extends StatelessWidget {
  const _ImportantTagsList({required this.tagsList}) : super();
  final List<Tag> tagsList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 338,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                i18nTranslate(context, 'user_important'),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  letterSpacing: calcLetterSpacing(letter: 4),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFFF8C00),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/user/add.svg',
                      color: const Color(0xFFFF8C00),
                      width: 7,
                      height: 7,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Wrap(
            spacing: 5,
            runSpacing: 10,
            children: tagsList
                .map((tag) => ImportantTagListItem(
                      tag: tag,
                      onSelect: () {},
                      isSelected: true,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
