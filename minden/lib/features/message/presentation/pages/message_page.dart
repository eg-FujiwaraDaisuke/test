import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/message/data/datasources/message_datasource.dart';
import 'package:minden/features/message/data/repositories/message_repository_impl.dart';
import 'package:minden/features/message/domain/entities/message.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/features/message/domain/usecases/message_usecase.dart';
import 'package:minden/features/message/presentation/bloc/message_bloc.dart';
import 'package:minden/features/message/presentation/pages/minden_message_dialog.dart';
import 'package:minden/features/message/presentation/pages/power_plant_message_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/utile.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late GetMessagesBloc _getMessagesBloc;

  @override
  void initState() {
    super.initState();
    _getMessagesBloc = GetMessagesBloc(
      const MessageInitial(),
      GetMessages(
        MessageRepositoryImpl(
          dataSource: MessageDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _getMessagesBloc.stream.listen((event) async {
      if (event is MessageError) {
        if (event.needLogin) {
          BlocProvider.of<LogoutBloc>(context).add(LogoutEvent());
          await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
              (_) => false);
        }
      }
    });
    _getMessagesBloc.add(GetMessagesEvent('1'));
  }

  @override
  void dispose() {
    _getMessagesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildBackLeadingButton(context),
        title: Text(
          i18nTranslate(context, 'user_menu_message'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 100),
            width: MediaQuery.of(context).size.width,
            child: BlocProvider.value(
              value: _getMessagesBloc,
              child: BlocListener<GetMessagesBloc, MessageState>(
                listener: (context, state) {
                  if (state is MessagesLoading) {
                    Loading.show(context);
                    return;
                  }
                  Loading.hide();
                },
                // TODO 下まで行ったら次の20件を取得する
                child: BlocBuilder<GetMessagesBloc, MessageState>(
                  builder: (context, state) {
                    if (state is MessagesLoaded) {
                      return _MessagesList(messages: state.messages);
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackLeadingButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/common/leading_back.svg',
        width: 44,
        height: 44,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      color: Colors.black,
    );
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList({required this.messages});
  final Messages messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: messages.messages
          .map(
            (message) => _MessagesListItem(
              messageDetail: message,
            ),
          )
          .toList(),
    );
  }
}

class _MessagesListItem extends StatefulWidget {
  const _MessagesListItem({required this.messageDetail});
  final MessageDetail messageDetail;

  @override
  _MessagesListItemState createState() => _MessagesListItemState();
}

class _MessagesListItemState extends State<_MessagesListItem> {
  late GetPowerPlantBloc _getPowerPlantsBloc;
  late ReadMessageBloc _readMessageBloc;

  @override
  void initState() {
    super.initState();

    _getPowerPlantsBloc = GetPowerPlantBloc(
      const PowerPlantStateInitial(),
      GetPowerPlant(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );
    _getPowerPlantsBloc
        .add(GetPowerPlantEvent(plantId: widget.messageDetail.plantId));

    _readMessageBloc = ReadMessageBloc(
      const MessageInitial(),
      ReadMessage(
        MessageRepositoryImpl(
          dataSource: MessageDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _getPowerPlantsBloc.close();
    _readMessageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _readMessageBloc
            .add(ReadMessageEvent(messageId: widget.messageDetail.messageId));
        if (widget.messageDetail.messageType == '1') {
          MindenMessageDialog(
                  context: context, messageDetail: widget.messageDetail)
              .showDialog();
        } else {
          PowerPlantMessageDialog(
                  context: context, messageDetail: widget.messageDetail)
              .showDialog();
        }
      },
      child: Container(
        width: 288,
        margin: const EdgeInsets.only(top: 25),
        padding: const EdgeInsets.only(bottom: 13),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFC4C4C4),
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.messageDetail.image == null)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCF6DA),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/message/minden_thumbnail.png',
                        width: 57,
                        height: 54,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 64,
                    height: 64,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.messageDetail.image!,
                      placeholder: (context, url) {
                        return Image.asset(
                          'assets/images/power_plant/power_plant_header_bg.png',
                          fit: BoxFit.cover,
                        );
                      },
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.messageDetail.read
                                  ? ''
                                  : i18nTranslate(
                                      context, 'thanks_message_new'),
                              style: TextStyle(
                                color: const Color(0xFFFF8C00),
                                fontSize: 12,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w700,
                                letterSpacing: calcLetterSpacing(letter: 0.5),
                              ),
                            ),
                            if (widget.messageDetail.messageType == '1')
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    'みんな電力からのお知らせ',
                                    style: TextStyle(
                                      color: const Color(0xFF787877),
                                      fontSize: 10,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing:
                                          calcLetterSpacing(letter: 0.5),
                                    ),
                                  ),
                                ),
                              )
                            else
                              BlocProvider.value(
                                value: _getPowerPlantsBloc,
                                child: BlocBuilder<GetPowerPlantBloc,
                                    PowerPlantState>(
                                  builder: (context, state) {
                                    if (state is PowerPlantLoaded) {
                                      return Flexible(
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Text(
                                            state.powerPlant.name!,
                                            style: TextStyle(
                                              color: const Color(0xFF787877),
                                              fontSize: 10,
                                              fontFamily: 'NotoSansJP',
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: calcLetterSpacing(
                                                  letter: 0.5),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          widget.messageDetail.title,
                          style: const TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 13,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        widget.messageDetail.created.toString().toString(),
                        style: const TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 10,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
