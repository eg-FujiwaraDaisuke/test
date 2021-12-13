import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/data/repositories/tag_repository_impl.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/domain/usecases/tag_usecase.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_bloc.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_event.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_tags_page.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_bloc.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_event.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_state.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_arc_painter.dart';
import 'package:minden/injection_container.dart';
import 'package:minden/utile.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileEditPageState();
  }
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UpdateProfileBloc _updateBloc;
  late GetProfileBloc _getBloc;
  late UpdateTagBloc _updateTagBloc;

  late String _wallPaperUrl;
  late String _iconUrl;
  late String _name;
  late String _bio;
  late bool _isDirtyName;
  late bool _isDirtyBio;
  late List<Tag?> _tags;

  @override
  void initState() {
    super.initState();

    _isDirtyName = false;
    _isDirtyBio = false;

    _name = '';
    _bio = '';
    _wallPaperUrl = '';
    _iconUrl = '';
    _tags = [];

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
      if (event is ProfileLoaded) {
        if (_tags.isNotEmpty) {
          _tags.removeWhere((element) => element == null);
          _updateTagBloc
              .add(UpdateTagEvent(tags: _tags.map((e) => e!.tagId).toList()));
          return;
        }
        Navigator.pop(context, true);
      }
    });

    _updateTagBloc = UpdateTagBloc(
      const TagStateInitial(),
      UpdateTags(
        TagRepositoryImpl(
          dataSource: TagDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );
    _updateTagBloc.stream.listen((event) {
      if (event is TagUpdated) {
        Navigator.pop(context, true);
      }
    });

    _getBloc.add(GetProfileEvent(userId: si<Account>().userId));
  }

  @override
  void dispose() {
    _updateBloc.close();
    _getBloc.close();
    _updateTagBloc.close();
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
            if (state is ProfileLoaded) {
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
                                color: Color(0xFF575292),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.antiAlias,
                              children: [
                                _ProfileWallPaperEdit(
                                  imageUrl: state.profile.wallPaper,
                                  imageHandler: (value) {
                                    _wallPaperUrl = value;
                                  },
                                ),
                                Positioned(
                                  child: _ProfileIconEdit(
                                    imageUrl: state.profile.icon,
                                    imageHandler: (value) {
                                      _iconUrl = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            _ProfileNameEditForm(
                              name: state.profile.name,
                              textHandler: (value) {
                                _isDirtyName = true;
                                _name = value;
                              },
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            _ProfileBioEditForm(
                              bio: state.profile.bio,
                              textHandler: (value) {
                                _isDirtyBio = true;
                                _bio = value;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            _ImportantTagsList(
                              tagsList: state.profile.tags,
                              tagHandler: (tags) {
                                _tags = tags;
                              },
                            ),
                          ],
                        ),
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
        _isDirtyName ||
        _bio.isNotEmpty ||
        _isDirtyBio ||
        _tags.isNotEmpty;
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
                title: Text(
                  i18nTranslate(context, 'profile_edit_alert_discard'),
                ),
                content: Text(
                  i18nTranslate(context, 'profile_edit_alert_discard_confirm'),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      i18nTranslate(context, 'cancel_katakana'),
                    ),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      i18nTranslate(context, 'discard'),
                    ),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(
                  i18nTranslate(context, 'profile_edit_alert_discard'),
                ),
                content: Text(
                  i18nTranslate(context, 'profile_edit_alert_discard_confirm'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      i18nTranslate(context, 'cancel_katakana'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      i18nTranslate(context, 'discard'),
                    ),
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _updateBloc.add(UpdateProfileEvent(
          name: _name, icon: _iconUrl, bio: _bio, wallPaper: _wallPaperUrl));
    }
  }
}

class _ProfileWallPaperEdit extends StatefulWidget {
  const _ProfileWallPaperEdit({
    required this.imageUrl,
    required this.imageHandler,
  });

  final String? imageUrl;
  final Function(String url) imageHandler;

  @override
  _ProfileWallPaperEditState createState() => _ProfileWallPaperEditState();
}

class _ProfileWallPaperEditState extends State<_ProfileWallPaperEdit> {
  bool _queuing = false;
  String _url = '';

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl?.isNotEmpty ?? false) {
      _url = widget.imageUrl!;
    }
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
            clipBehavior: Clip.none,
            children: [
              if (_url.isEmpty)
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 173,
                    color: const Color(0xFFFFFB92))
              else
                CachedNetworkImage(
                  imageUrl: _url,
                  width: MediaQuery.of(context).size.width,
                  height: 173,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 173,
                      color: const Color(0xFFFFFB92),
                    );
                  },
                  errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: 173,
                    color: const Color(0xFFFFFB92),
                  ),
                ),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 173),
                painter: WallPaperArcPainter(color: const Color(0xFFF6F5EF)),
              ),
              const SizedBox(
                height: 212,
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
                      cropStyle: CropStyle.rectangle,
                      clipHeight: 173,
                      clipWidth: 375,
                    );
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
        },
      ),
    );
  }
}

class _ProfileIconEdit extends StatefulWidget {
  const _ProfileIconEdit({
    required this.imageUrl,
    required this.imageHandler,
  });

  final String? imageUrl;
  final Function(String url) imageHandler;

  @override
  _ProfileIconEditState createState() => _ProfileIconEditState();
}

class _ProfileIconEditState extends State<_ProfileIconEdit> {
  bool _queuing = false;
  String _url = '';

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl?.isNotEmpty ?? false) {
      _url = widget.imageUrl!;
    }
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
                    color: Color(0xFFFFFFFF),
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
                      cropStyle: CropStyle.rectangle,
                    );
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
    required this.textHandler,
  });

  final String? name;
  final Function(String text) textHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            maxLength: 20,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Color(0xFF7C7C7C),
              fontSize: 18,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w700,
            ),
            validator: (value) {
              if ((value?.length ?? 0) < 2) {
                return i18nTranslate(context, 'user_name_length_error');
              }
            },
            onSaved: (value) {
              if (value != null) {
                textHandler(value);
              }
            },
            onChanged: textHandler,
          ),
        ),
      ],
    );
  }
}

class _ProfileBioEditForm extends StatelessWidget {
  const _ProfileBioEditForm({
    required this.bio,
    required this.textHandler,
  }) : super();
  final String? bio;
  final Function(String text) textHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18nTranslate(context, 'profile_edit_self_intro'),
          style: TextStyle(
            color: const Color(0xFF575292),
            fontSize: 14,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
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
            onSaved: (value) {
              if (value != null) {
                textHandler(value);
              }
            },
            onChanged: textHandler,
          ),
        ),
      ],
    );
  }
}

class _ImportantTagsList extends StatefulWidget {
  const _ImportantTagsList({
    required this.tagsList,
    required this.tagHandler,
  });

  final List<Tag> tagsList;
  final Function(List<Tag?> url) tagHandler;

  @override
  State<StatefulWidget> createState() {
    return _ImportantTagsListState();
  }
}

class _ImportantTagsListState extends State<_ImportantTagsList> {
  late List<Tag?> _tagsList;

  @override
  void initState() {
    super.initState();
    _tagsList = widget.tagsList;
  }

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
                  color: const Color(0xFF575292),
                  fontSize: 14,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  letterSpacing: calcLetterSpacing(letter: 4),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final ret = await Navigator.push<List<Tag?>>(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ProfileSettingTagsPage(
                        isRouteToPop: true,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return const FadeUpwardsPageTransitionsBuilder()
                            .buildTransitions(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileSettingTagsPage(
                                          isRouteToPop: true,
                                        ),
                                    settings: const RouteSettings(
                                        name: '/profileSetting/tag')),
                                context,
                                animation,
                                secondaryAnimation,
                                child);
                      },
                    ),
                  );
                  if (ret?.isNotEmpty ?? false) {
                    setState(() {
                      _tagsList = ret!;
                      widget.tagHandler(_tagsList);
                    });
                  }
                },
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
            children: _tagsList
                .map((tag) => TagListItem(
                      tag: tag,
                      onSelect: (tag) {},
                      isSelected: true,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
