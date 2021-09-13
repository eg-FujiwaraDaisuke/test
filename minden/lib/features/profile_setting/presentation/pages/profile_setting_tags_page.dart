import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/data/repositories/tag_repository_impl.dart';
import 'package:minden/features/profile_setting/domain/usecases/update_tag.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_bloc.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_event.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_tags_decision_page.dart';
import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/utile.dart';

class ProfileSettingTagsPage extends StatefulWidget {
  @override
  _ProfileSettingTagsPageState createState() => _ProfileSettingTagsPageState();
}

class _ProfileSettingTagsPageState extends State<ProfileSettingTagsPage> {
  final List<Tag> _selectedTags = [];
  late GetAllTagsBloc _allTagBloc;
  late UpdateTagBloc _updateTagBloc;

  @override
  void initState() {
    super.initState();

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
        final route = MaterialPageRoute(
          builder: (context) => ProfileSettingTagsDecisionPage(),
          settings: const RouteSettings(name: '/profileSetting/tagsDecision'),
        );
        Navigator.push(context, route);
      }
    });

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
    _allTagBloc.add(const GetTagEvent());
  }

  @override
  void dispose() {
    _allTagBloc.close();
    _updateTagBloc.close();
    super.dispose();
  }

  void _onSelectTag(Tag tag) {
    if (_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.remove(tag);
      });
    } else {
      if (_selectedTags.length >= 4) {
        // タグは4つ以下 alertを表示する
        return;
      }

      setState(() {
        _selectedTags.add(tag);
      });
    }
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
                Image.asset(
                  'assets/images/profile_setting/hukidasi_illust.png',
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
                        child: Image.asset(
                          'assets/images/profile_setting/character.png',
                          fit: BoxFit.contain,
                          width: 92,
                          height: 86,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 186,
                          height: 134,
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset(
                                  'assets/images/profile_setting/fukidasi.png',
                                  fit: BoxFit.contain,
                                  width: 186,
                                  height: 134,
                                ),
                                Text(
                                  '普段気にかけていることや\n目指していること、好きなことや\n気になっていることなどでも\nOKです',
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
                    },
                    child: BlocBuilder<GetAllTagsBloc, TagState>(
                      builder: (context, state) {
                        if (state is CategoryGetSucceed) {
                          return Column(
                            children: state.category
                                .map((e) => _TagsList(
                                      tagsList: e.tags,
                                      onSelect: _onSelectTag,
                                      selectedTags: _selectedTags,
                                      color: const Color(0xFFFFC2BE),
                                      title: e.categoryName,
                                    ))
                                .toList(),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                if (_selectedTags.isEmpty)
                  Botton(
                    onTap: () => {},
                    text: i18nTranslate(context, 'profile_setting_next'),
                    size: BottonSize.S,
                    isActive: false,
                  )
                else
                  Botton(
                    onTap: _next,
                    text: i18nTranslate(context, 'profile_setting_next'),
                    size: BottonSize.S,
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
    Navigator.pop(context);
  }

  void _next() {
    print("${_selectedTags.map((e) => e.tagId).toList()}");
    _updateTagBloc
        .add(UpdateTagEvent(tags: _selectedTags.map((e) => e.tagId).toList()));
  }
}

class _TagsList extends StatefulWidget {
  const _TagsList(
      {required this.tagsList,
      required this.onSelect,
      required this.selectedTags,
      required this.color,
      required this.title})
      : super();

  final List<Tag> tagsList;
  final List<Tag> selectedTags;
  final Function onSelect;
  final Color color;
  final String title;

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<_TagsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13), topRight: Radius.circular(13)),
              color: widget.color,
            ),
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF787877),
                ),
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
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 10,
              children: widget.tagsList
                  .map(
                    (tag) => ImportantTagListItem(
                      tag: tag,
                      onSelect: widget.onSelect,
                      isSelected: widget.selectedTags.contains(tag),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
