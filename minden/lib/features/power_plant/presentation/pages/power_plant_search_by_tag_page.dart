import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/hook/use_analytics.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/color_code_util.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_list_page.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/data/repositories/tag_repository_impl.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/domain/usecases/tag_usecase.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_bloc.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_event.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_tags_page.dart';
import 'package:minden/injection_container.dart';
import 'package:minden/utile.dart';

/// 大切にしていることから探す
class PowerPlantSearchByTag extends StatefulWidget {
  const PowerPlantSearchByTag({Key? key}) : super(key: key);

  static const String routeName = '/home/top/search/tag';

  @override
  _PowerPlantSearchByTagState createState() => _PowerPlantSearchByTagState();
}

class _PowerPlantSearchByTagState extends State<PowerPlantSearchByTag> {
  List<Tag?> _selectedTags = [];
  late GetAllTagsBloc _allTagBloc;
  late GetTagsBloc _tagBloc;

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
    });

    _allTagBloc.add(GetTagEvent());
    _tagBloc.add(GetTagEvent(userId: si<Account>().userId));
  }

  @override
  void dispose() {
    _allTagBloc.close();
    _tagBloc.close();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          i18nTranslate(context, 'power_plant_serch_by_important'),
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            color: const Color(0xFF575292),
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
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
          child: Container(
            alignment: Alignment.center,
            color: const Color(0xFFFAF9F8),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Image.asset(
                  'assets/images/profile_setting/hukidasi_illust.png',
                  fit: BoxFit.contain,
                  width: 213,
                  height: 65,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  i18nTranslate(
                      context, 'power_plant_serch_select_important_tag'),
                  style: TextStyle(
                    color: const Color(0xFF575292),
                    fontSize: 13,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    height: calcFontHeight(fontSize: 13, lineHeight: 17),
                  ),
                ),
                _buildCharacter(),
                const SizedBox(
                  height: 8,
                ),
                BlocProvider.value(
                  value: _tagBloc,
                  child: BlocListener<GetTagsBloc, TagState>(
                    listener: (context, state) {
                      if (state is TagLoading) {
                        Loading.show(context);
                        return;
                      }
                      Loading.hide();
                    },
                    child: BlocBuilder<GetTagsBloc, TagState>(
                      builder: (context, state) {
                        if (state is TagGetSucceed) {
                          return _buildSelectedTag(state.tags);
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 34,
                ),
                BlocProvider.value(
                  value: _allTagBloc,
                  child: BlocListener<GetAllTagsBloc, TagState>(
                      listener: (context, state) {
                    if (state is TagLoading) {
                      Loading.show(context);
                      return;
                    }
                    Loading.hide();
                  }, child: BlocBuilder<GetAllTagsBloc, TagState>(
                    builder: (context, state) {
                      if (state is CategoryGetSucceed) {
                        return Column(
                          children: state.category
                              .map((e) => TagsList(
                                    tagsList: e.tags,
                                    onSelect: _onSelectTag,
                                    selectedTags: _selectedTags,
                                    color: getColorFromCode(e.colorCode),
                                    title: e.categoryName,
                                  ))
                              .toList(),
                        );
                      }
                      return Container();
                    },
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSelectTag(Tag tag) async {
    setState(() {
      _selectedTags.add(tag);
    });

    useButtonAnalytics(ButtonAnalyticsType.navigateSearchByTagPowerPlant);

    // 検索結画面に飛ばす
    final route = MaterialPageRoute(
      builder: (context) => PowerPlantSearchListPage(selectTag: tag),
      settings: const RouteSettings(name: PowerPlantSearchListPage.routeName),
    );
    await Navigator.of(context, rootNavigator: true).push(route);
    setState(() {
      _selectedTags = [];
    });
  }

  Widget _buildCharacter() {
    return SizedBox(
      width: 318,
      height: 193,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 35,
            left: 1,
            child: Image.asset(
              'assets/images/power_plant/light.png',
              fit: BoxFit.contain,
              width: 72,
              height: 72,
            ),
          ),
          Positioned(
            bottom: 13,
            left: 1,
            child: Image.asset(
              'assets/images/power_plant/character.png',
              fit: BoxFit.contain,
              width: 97,
              height: 93,
            ),
          ),
          Positioned(
            left: 55,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/power_plant/fukidashi.png',
                  fit: BoxFit.contain,
                  width: 263,
                  height: 193,
                ),
                Positioned(
                  top: 41,
                  left: 30,
                  child: SizedBox(
                    width: 138,
                    child: Text(
                      i18nTranslate(context, 'power_plant_serch_who_make'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color(0xFF9A7446),
                          fontSize: 12,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          height:
                              calcFontHeight(fontSize: 12, lineHeight: 15.66),
                          letterSpacing: calcLetterSpacing(letter: -0.5)),
                    ),
                  ),
                ),
                Positioned(
                  top: 103,
                  left: 101,
                  child: SizedBox(
                    width: 130,
                    child: Text(
                      i18nTranslate(context, 'power_plant_serch_support_owner'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color(0xFF9A7446),
                          fontSize: 12,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          height:
                              calcFontHeight(fontSize: 12, lineHeight: 15.66),
                          letterSpacing: calcLetterSpacing(letter: -0.5)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectedTag(List<Tag> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18nTranslate(context, 'power_plant_serch_selected_tag'),
          style: const TextStyle(
            color: Color(0xFF575292),
            fontSize: 12,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 338,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Wrap(
            spacing: 5,
            runSpacing: 10,
            children: tags
                .map(
                  (tag) => TagListItem(
                    tag: tag,
                    onSelect: (tag) {},
                    isSelected: true,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
