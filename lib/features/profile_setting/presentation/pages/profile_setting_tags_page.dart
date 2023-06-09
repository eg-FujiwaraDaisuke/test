import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/hook/use_analytics.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/color_code_util.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/data/repositories/tag_repository_impl.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/domain/usecases/tag_usecase.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_bloc.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_event.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_tags_decision_page.dart';
import 'package:minden/gen/assets.gen.dart';
import 'package:minden/injection_container.dart';
import 'package:minden/utile.dart';

class ProfileSettingTagsPage extends StatefulWidget {
  static const String routeName = '/profileSetting/tag';

  ProfileSettingTagsPage({
    required this.isRouteToPop,
    this.profileSelectedTag,
  });

  // isRouteToPopがtrueの場合、このページ内でtagの更新APIを叩かない
  final bool isRouteToPop;
  final List<Tag>? profileSelectedTag;

  @override
  _ProfileSettingTagsPageState createState() => _ProfileSettingTagsPageState();
}

class _ProfileSettingTagsPageState extends State<ProfileSettingTagsPage> {
  final List<Tag> _selectedTags = [];
  late GetAllTagsBloc _allTagBloc;
  late GetTagsBloc _tagBloc;
  late UpdateTagBloc _updateTagBloc;

  @override
  void initState() {
    super.initState();
    _allTagBloc = GetAllTagsBloc(
      const TagStateInitial(),
      GetAllTags(
        TagRepositoryImpl(
          dataSource: TagDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );
    _allTagBloc.add(GetTagEvent());

    _tagBloc = GetTagsBloc(
      const TagStateInitial(),
      GetTags(
        TagRepositoryImpl(
          dataSource: TagDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _tagBloc.stream.listen((event) {
      if (event is TagLoading) {
        Loading.show(context);
        return;
      }
      Loading.hide();
      if (event is TagGetSucceed) {
        setState(() {
          if (widget.isRouteToPop) {
            _selectedTags.addAll(widget.profileSelectedTag!);
            return;
          }
          _selectedTags.addAll(event.tags);
        });
      }
    });
  }

  @override
  void dispose() {
    _allTagBloc.close();
    _tagBloc.close();
    super.dispose();
  }

  void _onSelectTag(Tag tag) {
    // 選択した選んだタグがすでに選択済みなのか判断する
    final foundTag = _selectedTags.firstWhereOrNull(
      (element) {
        return element.tagId == tag.tagId;
      },
    );

    // 選択済みなら解除する
    if (foundTag != null) {
      setState(() {
        _selectedTags.remove(foundTag);
      });
      return;
    }

    setState(() {
      _selectedTags.add(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: BlocListener<UpdateTagBloc, TagState>(
          listener: (_, state) {
            if (state is TagUpdated) {
              final route = MaterialPageRoute(
                builder: (context) => ProfileSettingTagsDecisionPage(),
                settings: const RouteSettings(
                    name: ProfileSettingTagsDecisionPage.routeName),
              );
                Navigator.push(context, route);
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 38),
                Text(
                  i18nTranslate(context, 'profile_setting_select_tag'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF575292),
                  ),
                ),
                const SizedBox(height: 19),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: i18nTranslate(
                            context, 'profile_setting_tag_description_you'),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: i18nTranslate(context,
                            'profile_setting_tag_description_important'),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFF8C00),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: i18nTranslate(
                            context, 'profile_setting_tag_description_wo'),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: i18nTranslate(
                            context, 'profile_setting_tag_description_select'),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7),
                Assets.images.profileSetting.hukidasiIllust.image(
                  fit: BoxFit.contain,
                  width: 213,
                  height: 65,
                ),
                SizedBox(
                  width: 262,
                  height: 134,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        bottom: 10,
                        child: Assets.images.profileSetting.character.image(
                          fit: BoxFit.contain,
                          width: 69,
                          height: 77,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SizedBox(
                          width: 186,
                          height: 134,
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Assets.images.profileSetting.fukidasi.image(
                                  fit: BoxFit.contain,
                                  width: 186,
                                  height: 134,
                                ),
                                Text(
                                  i18nTranslate(
                                      context, 'profile_setting_tag_fukidasi'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF9A7446),
                                    height: calcFontHeight(
                                        fontSize: 10, lineHeight: 14),
                                    letterSpacing:
                                        calcLetterSpacing(letter: -6),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  i18nTranslate(
                      context, 'profile_setting_important_tag_find_user'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF75C975),
                    height: calcFontHeight(fontSize: 12, lineHeight: 17.38),
                  ),
                ),
                const SizedBox(height: 15),
                BlocProvider.value(
                  value: _allTagBloc,
                  child: BlocListener<GetAllTagsBloc, TagState>(
                    listener: (context, state) {
                      if (state is TagLoading) {
                        Loading.show(context);
                        return;
                      }
                      Loading.hide();
                      if (state is CategoryGetSucceed) {
                        _tagBloc.add(GetTagEvent(userId: si<Account>().userId));
                      }
                    },
                    child: BlocBuilder<GetAllTagsBloc, TagState>(
                      builder: (context, state) {
                        if (state is CategoryGetSucceed) {
                          return Column(
                            children: state.category.map((e) {
                              return TagsList(
                                tagsList: e.tags,
                                onSelect: _onSelectTag,
                                selectedTags: _selectedTags,
                                color: getColorFromCode(e.colorCode),
                                title: e.categoryName,
                              );
                            }).toList(),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // 次へ
                if (_selectedTags.isEmpty || _selectedTags.length > 4)
                  Button(
                    onTap: () => {},
                    text: i18nTranslate(context, 'to_next'),
                    size: ButtonSize.S,
                    isActive: false,
                  )
                else
                  Button(
                    onTap: _next,
                    text: i18nTranslate(context, 'to_next'),
                    size: ButtonSize.S,
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _prev() {
    if (widget.isRouteToPop) {
      Navigator.pop(context, widget.profileSelectedTag);
      return;
    }
    Navigator.pop(context, _selectedTags);
  }

  // タグを選択 - 次へ押下
  void _next() {
    useButtonAnalytics(ButtonAnalyticsType.navigateConfirmTagSettings);

    if (widget.isRouteToPop) {
      Navigator.pop(context, _selectedTags);
      return;
    }
    context
        .read<UpdateTagBloc>()
        .add(UpdateTagEvent(tags: _selectedTags.map((e) => e.tagId).toList()));
  }
}

class TagsList extends StatefulWidget {
  const TagsList(
      {required this.tagsList,
      required this.onSelect,
      required this.selectedTags,
      required this.color,
      required this.title})
      : super();

  final List<Tag> tagsList;
  final List<Tag?> selectedTags;
  final Function onSelect;
  final Color color;
  final String title;

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13), topRight: Radius.circular(13)),
              color: widget.color,
            ),
            child: Text(
              '#${widget.title}',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w500,
                color: Color(0xFF787877),
              ),
            ),
          ),
          Container(
            width: 329,
            height: 2,
            color: widget.color,
          ),
          Container(
            width: 338,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Colors.white,
            ),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 10,
              children: widget.tagsList.map(
                (tag) {
                  return TagListItem(
                    tag: tag,
                    onSelect: widget.onSelect,
                    isSelected: widget.selectedTags.firstWhere((element) {
                          return element?.tagId == tag.tagId;
                        }, orElse: () => null) !=
                        null,
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
