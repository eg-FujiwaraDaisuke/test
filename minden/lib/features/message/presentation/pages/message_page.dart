import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/message/data/datasources/message_datasource.dart';
import 'package:minden/features/message/data/repositories/message_repository_impl.dart';
import 'package:minden/features/message/domain/entities/message_detail.dart';
import 'package:minden/features/message/domain/usecases/message_usecase.dart';
import 'package:minden/features/message/presentation/bloc/message_bloc.dart';
import 'package:minden/features/message/presentation/pages/minden_message_dialog.dart';
import 'package:minden/features/message/presentation/pages/power_plant_message_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:minden/features/message/presentation/viewmodel/messages_controller_provider.dart';
import 'package:minden/utile.dart';

class MessagePage extends HookWidget {
  late GetMessagesBloc _getMessagesBloc;

  @override
  Widget build(BuildContext context) {
    final messagesStateController =
        useProvider(messagesStateControllerProvider.notifier);
    final messagesStateData = useProvider(messagesStateControllerProvider);

    useEffect(() {
      if (messagesStateData.messages.isEmpty) {
        _getMessagesBloc = BlocProvider.of<GetMessagesBloc>(context);
        _getMessagesBloc.add(GetMessagesEvent('1'));
      }
    });
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
        child: Center(
          child: Container(
            color: Colors.white,
            width: 288,
            // messagesStateにデータが入ってない場合apiから取得する
            child: messagesStateData.messages.isEmpty
                ? BlocProvider.value(
                    value: _getMessagesBloc,
                    child: BlocListener<GetMessagesBloc, MessageState>(
                      listener: (context, state) {
                        if (state is MessagesLoading) {
                          Loading.show(context);
                          return;
                        }
                        Loading.hide();

                        if (state is MessagesLoaded) {
                          messagesStateController
                              .updateMessages(state.messages);
                        }
                      },
                      child: _MessagesList(),
                    ),
                  )
                : _MessagesList(),
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

class _MessagesList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    late ScrollController _scrollController;
    final messagesStateData = useProvider(messagesStateControllerProvider);
    useEffect(() {
      _scrollController = ScrollController();
      _scrollController.addListener(() {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentPosition = _scrollController.position.pixels;
        print(currentPosition);
        print(maxScrollExtent);
        if (maxScrollExtent > 0 && maxScrollExtent <= currentPosition) {
          print('取得');
        }
      });
      return () {
        _scrollController.dispose();
      };
    });

    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messagesStateData.messages.length,
        itemBuilder: (context, index) {
          return _MessagesListItem(
            messageDetail: messagesStateData.messages[index],
          );
        },
      ),
    );
  }
}

class _MessagesListItem extends HookWidget {
  _MessagesListItem({required this.messageDetail});
  final MessageDetail messageDetail;
  late ReadMessageBloc _readMessageBloc;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
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
      return () {
        _readMessageBloc.close();
      };
    });

    final dd = DateTime.fromMillisecondsSinceEpoch(messageDetail.created);
    final messagesStateController =
        useProvider(messagesStateControllerProvider.notifier);

    return GestureDetector(
      onTap: () {
        if (!messageDetail.read) {
          _readMessageBloc
              .add(ReadMessageEvent(messageId: messageDetail.messageId));
          messagesStateController.readMessage(messageDetail.messageId);
        }

        if (messageDetail.messageType == '1') {
          MindenMessageDialog(context: context, messageDetail: messageDetail)
              .showDialog();
        } else {
          PowerPlantMessageDialog(
            context: context,
            messageDetail: messageDetail,
          ).showDialog();
        }
      },
      child: Container(
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
                if (messageDetail.image == null)
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
                      imageUrl: messageDetail.image!,
                      placeholder: (context, url) {
                        return Image.asset(
                          'assets/images/power_plant/power_plant_header_bg.png',
                          fit: BoxFit.cover,
                        );
                      },
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/power_plant/power_plant_header_bg.png',
                        fit: BoxFit.cover,
                      ),
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
                            if (messageDetail.messageType == '1')
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    i18nTranslate(context, 'news_from_minden'),
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
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    messageDetail.title,
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          messageDetail.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                        '${dd.year}/${dd.month}',
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
