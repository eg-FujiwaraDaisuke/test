import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/hook/use_analytics.dart';
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/Issue_report/presentation/issue_report_complete_dialog.dart';
import 'package:minden/features/Issue_report/presentation/issue_report_dialog.dart';
import 'package:minden/features/Issue_report/presentation/issue_report_message_dialog.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_list_page.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/support_history_power_plant/presentation/pages/support_history_power_plant_list.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/features/user/presentation/pages/profile_edit_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_arc_painter.dart';
import 'package:minden/gen/assets.gen.dart';
import 'package:minden/injection_container.dart';
import 'package:minden/utile.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.userId});

  static const String routeName = '/user/profile';

  static Route<dynamic> route(String userId) {
    return MaterialPageRoute(
      builder: (context) => ProfilePage(userId: userId),
      settings: const RouteSettings(name: routeName),
    );
  }

  final String userId;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context)
        .add(GetProfileEvent(userId: widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMe = si<Account>().isMe(widget.userId);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
                if (isMe)
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push<bool>(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ProfileEditPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return const FadeUpwardsPageTransitionsBuilder()
                                .buildTransitions(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileEditPage(),
                                      settings: const RouteSettings(
                                          name: ProfileEditPage.routeName),
                                    ),
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child);
                          },
                        ),
                      );
                      // 常にリロード
                    },
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
                          SvgPicture.asset('assets/images/user/edit.svg'),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            i18nTranslate(context, 'user_edit'),
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
                  )
                else
                  GestureDetector(
                    onTap: () async {
                      // ユーザーの通報
                      useButtonAnalytics(
                          ButtonAnalyticsType.requestIssueReport);

                      final isShowReport = await IssueReportDialog(
                              context: context,
                              userName: state.profile.name ?? '')
                          .showDialog();
                      final isReport = isShowReport!
                          ? await IssueReportMessageDialog(
                              context: context,
                              targetUserId: widget.userId,
                            ).showDialog()
                          : false;

                      isReport!
                          ? IssueReportCompleteDialog(context: context)
                              .showDialog()
                          : null;
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      margin:
                          const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: const Center(
                        child: Icon(Icons.more_horiz),
                      ),
                    ),
                  )
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
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          if (state.profile.wallPaper?.isEmpty ?? true)
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 173,
                                color: const Color(0xFFFFFB92))
                          else
                            CachedNetworkImage(
                              imageUrl: state.profile.wallPaper!,
                              placeholder: (context, url) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 173,
                                    color: const Color(0xFFFFFB92));
                              },
                              errorWidget: (context, url, error) => Container(
                                width: MediaQuery.of(context).size.width,
                                height: 173,
                                color: const Color(0xFFFFFB92),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 173,
                              fit: BoxFit.cover,
                            ),
                          CustomPaint(
                            size: Size(MediaQuery.of(context).size.width, 173),
                            painter: WallPaperArcPainter(color: Colors.white),
                          ),
                          Positioned(
                            bottom: -44,
                            child: ProfileIcon(icon: state.profile.icon),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      ProfileName(
                        name: state.profile.name,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      // SNS
                      _buildSnsLinks(state),
                      const SizedBox(
                        height: 32,
                      ),
                      // 自己紹介
                      _ProfileBio(bio: state.profile.bio),
                      const SizedBox(
                        height: 43,
                      ),
                      _TagsList(
                        tagsList: state.profile.tags,
                      ),
                      const SizedBox(
                        height: 37,
                      ),
                      _SupportPowerPlant(
                        userId: widget.userId,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return PlaceHolderProfile();
        }
      },
    );
  }

  /// 対象ユーザーが設定しているSNSリンクを表示する
  Widget _buildSnsLinks(ProfileLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSnsLink(
          state.profile.instagramLink,
          'assets/images/user/sns_instagram.svg',
        ),
        _buildSnsLink(
          state.profile.facebookLink,
          'assets/images/user/sns_facebook.svg',
        ),
        _buildSnsLink(
          state.profile.twitterLink,
          'assets/images/user/sns_twitter.svg',
        ),
        _buildSnsLink(
          state.profile.freeLink,
          'assets/images/user/sns_free.svg',
        ),
      ],
    );
  }

  Widget _buildSnsLink(String? link, String assetName) {
    return Visibility(
      visible: link?.isNotEmpty ?? false,
      child: GestureDetector(
        onTap: () => _launchSnsLink(link!),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SvgPicture.asset(assetName),
        ),
      ),
    );
  }

  Future<void> _launchSnsLink(String link) async {
    if (await canLaunch(link)) {
      logD('This link is valid. link: $link');
      await launch(link);
    } else {
      logW('This link is invalid. link: $link');
    }
  }
}

class PlaceHolderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 173,
                    color: const Color(0xFFFFFB92)),
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 173),
                  painter: WallPaperArcPainter(color: Colors.white),
                ),
                const Positioned(
                  bottom: -44,
                  child: ProfileIcon(icon: ''),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({required this.icon});

  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            image: icon?.isEmpty ?? true
                ? null
                : DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(icon!),
                  ),
          ),
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({
    required this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name ?? '',
      style: const TextStyle(
        color: Color(0xFF575292),
        fontSize: 18,
        fontFamily: 'NotoSansJP',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ProfileBio extends StatelessWidget {
  const _ProfileBio({
    required this.bio,
  }) : super();
  final String? bio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 338,
      child: Linkify(
        onOpen: (link) async {
          if (await canLaunch(link.url)) {
            await launch(link.url);
          }
        },
        text: bio ?? '',
        style: TextStyle(
          color: const Color(0xFF787877),
          fontSize: 12,
          fontFamily: 'NotoSansJP',
          fontWeight: FontWeight.w400,
          letterSpacing: calcLetterSpacing(letter: 0.5),
          height: calcFontHeight(lineHeight: 22, fontSize: 12),
        ),
        linkStyle: const TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}

// 大切にしていること（タグ）
class _TagsList extends StatelessWidget {
  const _TagsList({required this.tagsList}) : super();
  final List<Tag> tagsList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 338,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(
            height: 4,
          ),
          Wrap(
            spacing: 5,
            runSpacing: 10,
            children: tagsList
                .map(
                  (tag) => TagListItem(
                    tag: tag,
                    onSelect: (tag) {
                      useButtonAnalytics(ButtonAnalyticsType
                          .navigateSearchByTagPowerPlantFromProfile);

                      // 検索結画面に飛ばす
                      final route = MaterialPageRoute(
                        builder: (context) =>
                            PowerPlantSearchListPage(selectTag: tag),
                        settings: const RouteSettings(
                            name: PowerPlantSearchListPage.routeName),
                      );
                      Navigator.push(context, route);
                    },
                    isSelected: true,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SupportPowerPlant extends StatelessWidget {
  const _SupportPowerPlant({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: 340,
            child: Text(
              i18nTranslate(context, 'user_support_plant'),
              style: TextStyle(
                color: const Color(0xFF575292),
                fontSize: 14,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
                letterSpacing: calcLetterSpacing(letter: 4),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        SupportHistoryPowerPlantList(
          historyType: 'reservation',
          userId: userId,
        ),
      ],
    );
  }
}
