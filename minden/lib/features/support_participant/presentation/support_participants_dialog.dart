import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/hook/use_analytics.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant_user.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';
import 'package:minden/gen/assets.gen.dart';

/// 発電所応援ダイアログ
class SupportParticipantsDialog {
  SupportParticipantsDialog({required this.context, required this.plantId})
      : super();

  static const String routeName = '/home/top/detail/supportParticipants';

  final BuildContext context;
  final String plantId;

  void showDialog() {
    Navigator.push(
      context,
      CustomDialogOverlay(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Stack(
            children: [
              Positioned(
                child: _DialogContent(plantId),
              ),
              Positioned(
                top: 25,
                right: 27,
                child: GestureDetector(
                  onTap: _hideDialog,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
        settings: const RouteSettings(name: routeName),
      ),
    );
  }

  /*
   * 非表示
   */
  void _hideDialog() {
    Navigator.of(context).pop();
  }
}

class _DialogContent extends StatefulWidget {
  const _DialogContent(
    this.plantId,
  );

  final String plantId;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  late GetParticipantAllUserBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetParticipantAllUserBloc(
      const PowerPlantStateInitial(),
      GetPowerPlantParticipantAllUser(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    )..add(GetPowerPlantEvent(plantId: widget.plantId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      padding: const EdgeInsets.only(top: 50, bottom: 31),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<GetParticipantAllUserBloc, PowerPlantState>(
          builder: (context, state) {
            if (state is! AllParticipantLoaded) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final total_users = state.participant.participantSize;
            final users = state.participant.orderedUserList;
            final fromWebUsers = total_users - users.length;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (users.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: i18nTranslate(context, 'now'),
                          style: const TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 16,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '''
${users.length.toString()}${i18nTranslate(context, 'support_participants_people')}''',
                          style: const TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 16,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: i18nTranslate(
                              context, 'support_participants_supporting'),
                          style: const TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 16,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(
                  height: 27,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 240,
                    maxWidth: 286,
                    minWidth: 286,
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _buildParticipantItem(users[index]);
                    },
                    shrinkWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                if (fromWebUsers > 0) ...[
                  Container(
                    color: const Color(0xFFDADADA),
                    width: 287,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        i18nTranslate(
                          context,
                          'support_participants_support_from_web',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFF8C00),
                          fontSize: 14,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 29,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$fromWebUsers',
                              style: const TextStyle(
                                color: Color(0xFFFF8C00),
                                fontSize: 14,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: i18nTranslate(
                                context,
                                'support_participants_people',
                              ),
                              style: const TextStyle(
                                color: Color(0xFFFF8C00),
                                fontSize: 14,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildParticipantItem(PowerPlantParticipantUser participant) {
    var name = participant.name ?? '';
    final child = Column(
      children: [
        Container(
          width: 47,
          height: 47,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: participant.hasIcon
                ? CachedNetworkImage(
                    imageUrl: participant.icon!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Image.asset(
                        'assets/images/user/icon_no_photo.png',
                        fit: BoxFit.cover,
                      );
                    },
                    errorWidget: (context, url, error) =>
                        Assets.images.common.noimage.image(fit: BoxFit.cover),
                  )
                : Image.asset(
                    'assets/images/user/icon_no_photo.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 66,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFF8C00),
              fontSize: 11,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );

    // 名前が設定されているユーザーのみ、プロフィール画面が見られるようにする
    if (participant.name?.isNotEmpty ?? false) {
      return GestureDetector(
        onTap: () {
          // 応援ユーザーアイコンのタップ
          useButtonAnalytics(ButtonAnalyticsType.navigateParticipantUser);

          final route = MaterialPageRoute(
            builder: (context) => ProfilePage(
              userId: participant.userId,
            ),
            settings: const RouteSettings(name: ProfilePage.routeName),
          );
          Navigator.push(context, route);
        },
        child: child,
      );
    } else {
      return child;
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
