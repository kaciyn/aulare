import 'package:aulare/models/contact.dart';
import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/messaging_page.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:aulare/views/messaging/widgets/message_input.dart';
import 'package:aulare/views/messaging/widgets/messaging_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rubber/rubber.dart';

class ConversationPageSlide extends StatefulWidget {
  const ConversationPageSlide({this.startContact});

  @override
  _ConversationPageSlideState createState() =>
      _ConversationPageSlideState(startContact);

  final Contact startContact;
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {
  _ConversationPageSlideState(this.startContact);

  var controller;
  PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Contact startContact;
  MessagingBloc conversationBloc;
  List<Conversation> conversationList = [];
  bool isFirstLaunch = true;

  @override
  void initState() {
    conversationBloc = BlocProvider.of<MessagingBloc>(context);
    conversationBloc.add(FetchConversationList());
    controller = RubberAnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: <Widget>[
                BlocListener<MessagingBloc, MessagingState>(
                    // bloc: conversationBloc,
                    listener: (bc, state) {
                  print('ConversationList $conversationList');
                  if (isFirstLaunch && conversationList.isNotEmpty) {
                    isFirstLaunch = false;
                    for (var i = 0; i < conversationList.length; i++) {
                      if (startContact.username ==
                          conversationList[i].user.username) {
                        BlocProvider.of<MessagingBloc>(context)
                            .add(ScrollPage(i, conversationList[i]));
                        pageController.jumpToPage(i);
                      }
                    }
                  }
                }, child: Expanded(
                        child: BlocBuilder<MessagingBloc, MessagingState>(
                  builder: (context, state) {
                    if (state is ConversationListFetched) {
                      conversationList = state.conversations;
                    }
                    return PageView.builder(
                        controller: pageController,
                        itemCount: conversationList.length,
                        onPageChanged: (index) =>
                            BlocProvider.of<MessagingBloc>(context).add(
                                ScrollPage(index, conversationList[index])),
                        itemBuilder: (bc, index) =>
                            MessagingPage(conversationList[index]));
                  },
                ))),
                Container(
                    child: GestureDetector(
                        child: MessageInput(),
                        onPanUpdate: (details) {
                          if (details.delta.dy < 0) {
                            _scaffoldKey.currentState
                                .showBottomSheet<Null>((BuildContext context) {
                              return const MessagingBottomSheet();
                            });
                          }
                        }))
              ],
            )));
  }
}
