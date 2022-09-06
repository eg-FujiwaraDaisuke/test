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
import 'package:minden/core/hook/use_analytics.dart';
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
import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_arc_painter.dart';
import 'package:minden/gen/assets.gen.dart';
import 'package:minden/injection_container.dart';
import 'package:minden/utile.dart';

class ProfileEditPage extends StatefulWidget {
  static const String routeName = '/user/profile/edit';

  @override
  State<StatefulWidget> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UpdateProfileBloc _updateBloc;
  late GetProfileBloc _getProfileBloc;
  late UpdateTagBloc _updateTagBloc;

  late String? _wallPaperUrl;
  late String? _iconUrl;
  late String? _name;
  late String? _bio;
  late List<Tag> _tags;
  late Profile _profile;

  // SNS
  late String? _instagramLink;
  late String? _facebookLink;
  late String? _twitterLink;
  late String? _freeLink;

  @override
  void initState() {
    super.initState();

    _getProfileBloc = GetProfileBloc(
      const ProfileStateInitial(),
      GetProfile(
        ProfileRepositoryImpl(
          dataSource: ProfileDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );
    _getProfileBloc.stream.listen((event) {
      if (event is ProfileLoaded) {
        setState(() {
          _profile = event.profile;
          _name = event.profile.name;
          _bio = event.profile.bio;
          _wallPaperUrl = event.profile.wallPaper;
          _instagramLink = event.profile.instagramLink;
          _facebookLink = event.profile.facebookLink;
          _twitterLink = event.profile.twitterLink;
          _freeLink = event.profile.freeLink;
          _iconUrl = event.profile.icon;
          _tags = event.profile.tags;
        });
      }
    });

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
              .add(UpdateTagEvent(tags: _tags.map((e) => e.tagId).toList()));
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

    _getProfileBloc.add(GetProfileEvent(userId: si<Account>().userId));
  }

  @override
  void dispose() {
    _updateBloc.close();
    _getProfileBloc.close();
    _updateTagBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _getProfileBloc,
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
                        Assets.images.common.leadingBack,
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
                                  imageUrl: _wallPaperUrl,
                                  imageHandler: (value) {
                                    _wallPaperUrl = value;
                                  },
                                ),
                                Positioned(
                                  child: _ProfileIconEdit(
                                    imageUrl: _iconUrl,
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
                              name: _name,
                              textHandler: (value) {
                                setState(() {
                                  _name = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            // 自己紹介
                            _ProfileBioEditForm(
                              bio: _bio,
                              textHandler: (value) {
                                setState(() {
                                  _bio = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // 大切にしていること
                            _ImportantTagsList(
                              tagsList: _tags,
                              tagHandler: (tags) {
                                setState(() {
                                  _tags = tags;
                                });
                              },
                            ),
                            const SizedBox(height: 38),
                            // SNS
                            _SnsLinkEditForm(
                              prefixIconKey:
                                  'assets/images/user/input_sns_instagram.svg',
                              placeholderKey: 'profile_setting_sns_instagram',
                              link: _instagramLink,
                              validateDomains: const [
                                'www.instagram.com',
                                'instagram.com'
                              ],
                              textHandler: (value) {
                                _instagramLink = value;
                              },
                              hasSectionTitle: true,
                            ),
                            _SnsLinkEditForm(
                              prefixIconKey:
                                  'assets/images/user/input_sns_facebook.svg',
                              placeholderKey: 'profile_setting_sns_facebook',
                              link: _facebookLink,
                              validateDomains: const ['www.facebook.com'],
                              textHandler: (value) {
                                _facebookLink = value;
                              },
                            ),
                            _SnsLinkEditForm(
                              prefixIconKey:
                                  'assets/images/user/input_sns_twitter.svg',
                              placeholderKey: 'profile_setting_sns_twitter',
                              link: _twitterLink,
                              validateDomains: const ['twitter.com'],
                              textHandler: (value) {
                                _twitterLink = value;
                              },
                            ),
                            _SnsLinkEditForm(
                              prefixIconKey:
                                  'assets/images/user/input_sns_free.svg',
                              placeholderKey: 'profile_setting_sns_free',
                              link: _freeLink,
                              textHandler: (value) {
                                _freeLink = value;
                              },
                            ),
                            const SizedBox(height: 24),
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

  /// 編集画面を開いたときから、設定が変更されているか
  bool _isDirty() {
    final isChangedIcon = _iconUrl != _profile.icon;
    final isChangedWallpaper = _wallPaperUrl != _profile.wallPaper;
    final isChangedName = _name != _profile.name;
    final isChangedBio = _bio != _profile.bio;
    final isChangedTags = _tags != _profile.tags;
    final isChangedInstagram = _instagramLink != _profile.instagramLink;
    final isChangedFacebook = _facebookLink != _profile.facebookLink;
    final isChangedTwitter = _twitterLink != _profile.twitterLink;
    final isChangedFreeUrl = _freeLink != _profile.freeLink;

    return isChangedIcon ||
        isChangedWallpaper ||
        isChangedName ||
        isChangedBio ||
        isChangedTags ||
        isChangedInstagram ||
        isChangedFacebook ||
        isChangedTwitter ||
        isChangedFreeUrl;
  }

  Future<void> _prev(BuildContext context) async {
    if (!_isDirty()) {
      // 変更がない場合、無条件でpop
      Navigator.pop(context, false);
      return;
    }

    // 変更されている場合、変更を破棄して戻るか確認
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
      useButtonAnalytics(ButtonAnalyticsType.completeTagSettings);

      _formKey.currentState!.save();

      _updateBloc.add(UpdateProfileEvent(
        name: _name!,
        icon: _iconUrl ?? '',
        bio: _bio!,
        wallPaper: _wallPaperUrl ?? '',
        freeLink: _freeLink ?? '',
        twitterLink: _twitterLink ?? '',
        facebookLink: _facebookLink ?? '',
        instagramLink: _instagramLink ?? '',
      ));
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
                    // 背景編集
                    useButtonAnalytics(
                        ButtonAnalyticsType.requestChangeProfileWallpaper);

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
                        Assets.images.common.camera,
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
                    // アイコン編集
                    useButtonAnalytics(
                        ButtonAnalyticsType.requestChangeProfileIcon);

                    ImagePickerBottomSheet.show(
                      context: context,
                      imageHandler: (value) {
                        _queuing = true;
                        BlocProvider.of<UploadBloc>(context)
                            .add(UploadMediaEvent(value));
                      },
                      cropStyle: CropStyle.circle,
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
                        Assets.images.common.camera,
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
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
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
              fontSize: 16,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w700,
            ),
            validator: (value) {
              if ((value?.length ?? 0) < 2) {
                return i18nTranslate(context, 'user_name_length_error');
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
        _generateSectionTitle(context, 'profile_edit_self_intro'),
        const SizedBox(height: 8),
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
              fontSize: 16,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w400,
              letterSpacing: calcLetterSpacing(letter: 0.5),
              height: calcFontHeight(lineHeight: 22.08, fontSize: 16),
            ),
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
  final Function(List<Tag> url) tagHandler;

  @override
  State<StatefulWidget> createState() {
    return _ImportantTagsListState();
  }
}

class _ImportantTagsListState extends State<_ImportantTagsList> {
  @override
  void initState() {
    super.initState();
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
              _generateSectionTitle(context, 'user_important'),
              GestureDetector(
                onTap: () async {
                  // 大切にしていること編集
                  useButtonAnalytics(
                      ButtonAnalyticsType.requestChangeProfileTags);

                  final ret = await Navigator.push<List<Tag>>(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                      ) =>
                          ProfileSettingTagsPage(
                        isRouteToPop: true,
                        profileSelectedTag: widget.tagsList,
                      ),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return const FadeUpwardsPageTransitionsBuilder()
                            .buildTransitions(
                          MaterialPageRoute(
                            builder: (context) => ProfileSettingTagsPage(
                              isRouteToPop: true,
                              profileSelectedTag: widget.tagsList,
                            ),
                            settings: const RouteSettings(
                              name: ProfileSettingTagsPage.routeName,
                            ),
                          ),
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        );
                      },
                    ),
                  );

                  if (ret!.isNotEmpty) {
                    setState(() {
                      widget.tagHandler(ret);
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
            children: widget.tagsList
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

/// SNSリンクを編集するForm
class _SnsLinkEditForm extends StatelessWidget {
  const _SnsLinkEditForm({
    required this.prefixIconKey,
    required this.placeholderKey,
    required this.link,
    this.validateDomains = const [],
    required this.textHandler,
    this.hasSectionTitle = false,
  }) : super();

  static TextStyle formTextStyle = TextStyle(
    color: const Color(0xFF7C7C7C),
    fontSize: 12,
    fontFamily: 'NotoSansJP',
    fontWeight: FontWeight.w400,
    letterSpacing: calcLetterSpacing(letter: 0.5),
    height: calcFontHeight(lineHeight: 22.08, fontSize: 12),
  );

  final String prefixIconKey;
  final String placeholderKey;
  final String? link;
  final List<String> validateDomains;
  final Function(String text) textHandler;
  final bool hasSectionTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasSectionTitle)
            _generateSectionTitle(context, 'profile_setting_sns'),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            width: 339,
            child: TextFormField(
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              initialValue: link,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
                  child: SvgPicture.asset(
                    prefixIconKey,
                    width: 18,
                    height: 18,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                hintText: i18nTranslate(context, placeholderKey),
                hintStyle: formTextStyle,
                fillColor: Colors.white,
                filled: true,
                isDense: true,
              ),
              style: formTextStyle,
              onChanged: textHandler,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  // 未入力なら何もしない
                  return null;
                }

                if (Uri.tryParse(value!)?.hasAbsolutePath ?? false) {
                  if (validateDomains.isEmpty) {
                    // バリデーション条件がないなら何もしない
                    return null;
                  } else {
                    final host = Uri.parse(value).host;
                    final validDomain = validateDomains
                        .map((domain) => RegExp('^$domain\$'))
                        .any((regexp) => regexp.hasMatch(host));

                    if (validDomain) {
                      // 問題なければ何もしない
                      return null;
                    } else {
                      // 要求するドメインが含まれていなければエラーを返す
                      return i18nTranslate(
                          context, 'user_sns_link_invalid_domain_error');
                    }
                  }

                  // 正しいurlなら何もしない
                  return null;
                } else {
                  return i18nTranslate(context, 'user_sns_link_invalid_error');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 設定項目のタイトルを生成して返す
Widget _generateSectionTitle(
  BuildContext context,
  String titleKey,
) {
  return Text(
    i18nTranslate(context, titleKey),
    style: TextStyle(
      color: const Color(0xFF575292),
      fontSize: 14,
      fontFamily: 'NotoSansJP',
      fontWeight: FontWeight.w700,
      letterSpacing: calcLetterSpacing(letter: 4),
    ),
  );
}
