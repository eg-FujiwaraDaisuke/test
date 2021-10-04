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
import 'package:minden/utile.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late GetMessagesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetMessagesBloc(
      const MessageInitial(),
      GetMessages(
        MessageRepositoryImpl(
          dataSource: MessageDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _bloc.stream.listen((event) async {
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
    _bloc.add(GetMessagesEvent('1'));
  }

  @override
  void dispose() {
    _bloc.close();
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
              value: _bloc,
              child: BlocListener<GetMessagesBloc, MessageState>(
                listener: (context, state) {
                  if (state is MessagesLoading) {
                    Loading.show(context);
                    return;
                  }
                  Loading.hide();
                },
                child: BlocBuilder<GetMessagesBloc, MessageState>(
                  builder: (context, state) {
                    if (state is MessagesLoaded) {
                      return _buildMessageList(state.messages);
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

  Widget _buildMessageList(Messages messages) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: messages.messages
          .map((messageDetail) => _buildMessageListItem(messageDetail))
          .toList(),
    );
  }

  Widget _buildMessageListItem(MessageDetail messageDetail) {
    return GestureDetector(
      onTap: () {
        if (messageDetail.messageType == '1') {
          MindenMessageDialog(context: context, messageDetail: messageDetail)
              .showDialog();
        } else {
          PowerPlantMessageDialog(
                  context: context, messageDetail: messageDetail)
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
                if (messageDetail.image.isEmpty)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCF6DA),
                      borderRadius: BorderRadius.circular(9),
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
                      imageUrl: messageDetail.image,
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
                              messageDetail.read
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
                            Text(
                              // TODO ここに発電所の名前がはいる
                              messageDetail.plantId,
                              style: TextStyle(
                                color: const Color(0xFFFF8C00),
                                fontSize: 10,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w700,
                                letterSpacing: calcLetterSpacing(letter: 0.5),
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
                          messageDetail.title,
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
                        messageDetail.created.toString(),
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
