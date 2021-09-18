import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/home/presentation/pages/home_page.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/data/repositories/tag_repository_impl.dart';
import 'package:minden/features/profile_setting/domain/usecases/tag_usecase.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_bloc.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_event.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/injection_container.dart';

class ProfileSettingTagsDecisionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileSettingTagsDecisionPageState();
}

class _ProfileSettingTagsDecisionPageState
    extends State<ProfileSettingTagsDecisionPage> {
  late GetTagsBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = GetTagsBloc(
      const TagStateInitial(),
      GetTags(
        TagRepositoryImpl(
          dataSource: TagDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _bloc.add(GetTagEvent(userId: si<Account>().userId));
  }

  @override
  void dispose() {
    _bloc.close();
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
          onTap: () => _prev(context),
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
            children: [
              const SizedBox(height: 38),
              Text(
                i18nTranslate(context, 'profile_decision_tag'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF575292),
                ),
              ),
              const SizedBox(height: 43),
              Text(
                i18nTranslate(context, 'profile_decision_tag_set'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF787877),
                ),
              ),
              const SizedBox(height: 20),
              BlocProvider.value(
                value: _bloc,
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
                        return Container(
                          width: 338,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Colors.white,
                          ),
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 10,
                            children: state.tags
                                .map(
                                  (tag) => TagListItem(
                                    tag: tag,
                                    onSelect: (tag) {},
                                    isSelected: true,
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 112),
              Button(
                onTap: () => {_decide(context)},
                text: i18nTranslate(context, 'decide'),
                size: ButtonSize.S,
              ),
              const SizedBox(height: 19),
              GestureDetector(
                onTap: () => _prev(context),
                child: Text(
                  i18nTranslate(context, 'cancel_katakana'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF787877),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  void _prev(BuildContext context) {
    Navigator.pop(context);
  }

  void _decide(BuildContext context) {
    final route = NoAnimationMaterialPageRoute(
      builder: (context) => HomePage(),
      settings: RouteSettings(name: '/home'),
    );
    Navigator.pushReplacement(context, route);
  }
}
