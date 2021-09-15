import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/features/user/presentation/pages/profile_edit_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_arc_painter.dart';

import '../../../../injection_container.dart';
import '../../../../utile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late GetProfileBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = GetProfileBloc(
      const ProfileStateInitial(),
      GetProfile(
        ProfileRepositoryImpl(
          dataSource: ProfileDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _bloc.add(GetProfileEvent(userId: si<Account>().userId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
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
                        'assets/images/common/leading_back.svg',
                        fit: BoxFit.fill,
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push<bool>(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ProfileEditPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return const FadeUpwardsPageTransitionsBuilder()
                                  .buildTransitions(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileEditPage(),
                                          settings: const RouteSettings(
                                              name: '/user/profile/edit')),
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child);
                            },
                          ),
                        );

                        // 常にリロード
                        _bloc
                            .add(GetProfileEvent(userId: si<Account>().userId));
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
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              if (state.profile.wallPaper?.isEmpty ?? true)
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 173,
                                    color: const Color(0xFFFFFB92))
                              else
                                Image.network(
                                  state.profile.wallPaper,
                                  width: MediaQuery.of(context).size.width,
                                  height: 173,
                                  fit: BoxFit.cover,
                                ),
                              CustomPaint(
                                size: Size(
                                    MediaQuery.of(context).size.width, 174),
                                painter:
                                    WallPaperArcPainter(color: Colors.white),
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
                            height: 35,
                          ),
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
                          // TODO あとで共通Componentを組み込む
                          const _SelectedPlantList(selectedPlantList: [])
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
}

class PlaceHolderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 173,
                        color: const Color(0xFFFFFB92)),
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 174),
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
      child: Text(
        bio ?? '',
        style: TextStyle(
          color: const Color(0xFF787877),
          fontSize: 12,
          fontFamily: 'NotoSansJP',
          fontWeight: FontWeight.w400,
          letterSpacing: calcLetterSpacing(letter: 0.5),
          height: calcFontHeight(lineHeight: 22, fontSize: 12),
        ),
      ),
    );
  }
}

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
                  (tag) => ImportantTagListItem(
                    tag: tag,
                    onSelect: () {},
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

class _SelectedPlantList extends StatelessWidget {
  const _SelectedPlantList({required this.selectedPlantList});

  final selectedPlantList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18nTranslate(context, 'user_select_plant'),
          style: TextStyle(
            color: const Color(0xFF575292),
            fontSize: 14,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Column(
          children: [_SelectedPlantListItem()],
        ),
      ],
    );
  }
}

class _SelectedPlantListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 352,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
    );
  }
}
