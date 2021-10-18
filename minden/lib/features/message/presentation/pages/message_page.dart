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
  MessagePage({this.showMessageId});
  String? showMessageId;

  @override
  Widget build(BuildContext context) {
    late GetMessageDetailBloc _getMessageDetailBloc;
    late ReadMessageBloc _readMessageBloc;

    useEffect(() {
      if (showMessageId != null) {
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

        _getMessageDetailBloc = GetMessageDetailBloc(
          const MessageInitial(),
          GetMessageDetail(
            MessageRepositoryImpl(
              dataSource: MessageDataSourceImpl(
                client: http.Client(),
              ),
            ),
          ),
        );

        _getMessageDetailBloc.stream.listen((event) async {
          if (event is MessageDetailLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();

          if (event is MessageDetailLoaded) {
            _readMessageBloc.add(
                ReadMessageEvent(messageId: event.messageDetail.messageId));

            if (event.messageDetail.messageType == '1') {
              MindenMessageDialog(
                      context: context, messageDetail: event.messageDetail)
                  .showDialog();
            } else {
              PowerPlantMessageDialog(
                context: context,
                messageDetail: event.messageDetail,
              ).showDialog();
            }
          }
        });
        _getMessageDetailBloc
            .add(GetMessageDetailEvent(messageId: showMessageId!));
      }
      return () {
        _getMessageDetailBloc.close();
        _readMessageBloc.close();
      };
    }, []);

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
            child: _MessagesList(),
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
    late GetMessagesBloc _getMessagesBloc;
    late GetShowBadgeBloc _getShowBadgeBloc;

    final messagesStateData = useProvider(messagesStateControllerProvider);
    final messagesStateController =
        useProvider(messagesStateControllerProvider.notifier);
    final _isLoading = useState<bool>(false);

    useEffect(() {
      _getMessagesBloc = BlocProvider.of<GetMessagesBloc>(context);
      _getShowBadgeBloc = BlocProvider.of<GetShowBadgeBloc>(context);
      _scrollController = ScrollController();

      _scrollController.addListener(() {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentPosition = _scrollController.position.pixels;

        if (maxScrollExtent > 0 && maxScrollExtent <= currentPosition) {
          if (_isLoading.value) return;
          if (messagesStateData.page == messagesStateData.total) return;
          _isLoading.value = true;
          _getMessagesBloc
              .add(GetMessagesEvent((messagesStateData.page + 1).toString()));
        }
      });
      return () {
        _scrollController.dispose();
      };
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _getMessagesBloc),
        BlocProvider.value(value: _getShowBadgeBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetMessagesBloc, MessageState>(
            listener: (context, state) {
              if (state is MessagesLoading) {
                Loading.show(context);
                _isLoading.value = true;
                return;
              }
              Loading.hide();
              if (state is MessagesLoaded) {
                _isLoading.value = false;
                messagesStateController.addMessages(state.messages);
              }
            },
          ),
          BlocListener<GetShowBadgeBloc, MessageState>(
            listener: (context, state) {
              if (state is ShowBadgeLoaded) {
                messagesStateController.updateShowBadge(state.messages);
              }
            },
          ),
        ],
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 100),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messagesStateData.messages.length,
            itemBuilder: (context, index) {
              return _MessagesListItem(
                messageDetail: messagesStateData.messages[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MessagesListItem extends HookWidget {
  _MessagesListItem({required this.messageDetail});
  final MessageDetail messageDetail;
  late ReadMessageBloc _readMessageBloc;
  late GetShowBadgeBloc _getShowBadgeBloc;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _getShowBadgeBloc = BlocProvider.of<GetShowBadgeBloc>(context);
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
        // 未読ならviewmodelのreadをtrueに変える
        // apiを叩いて既読する
        if (!messageDetail.read) {
          _readMessageBloc
              .add(ReadMessageEvent(messageId: messageDetail.messageId));
          messagesStateController.readMessage(messageDetail.messageId);
        }

        // 未読バッチの有無を確認する
        _getShowBadgeBloc.add(GetShowBadgeEvent('1'));

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
