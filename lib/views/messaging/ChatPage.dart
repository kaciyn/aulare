import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'MessagingView.dart';
import 'components/Message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  //mixin lets class body be reused in multiple class hierarchies
  final _textController = TextEditingController();
  final List<Message> _messages = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
    // return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AULARE'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ], //nav will go in here, want it to be different in the different screens
      ),
      body: Column(
        children: [
          Flexible(
            //message list
            child: ListView.builder(
              itemBuilder: (_, int index) => _messages[index],
              reverse: true,
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1),
          Container(
              //text input
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer()),
        ],
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      // NEW lines from here...
      builder: (BuildContext context) {
        return Text('this is a page');
      },
    ));
  }

  @override
  void dispose() {
    //dispose animation controllers when you don't need them anymore!
    for (Message message in _messages) {
      message.animationController.dispose();
      super.dispose();
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          color: lightBlack,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            Flexible(
              child: TextField(
                textInputAction: TextInputAction.go,
                //can customise what key sends here i think, anyway you could set a toggle for enter to send/enter to newline
                maxLines: null,
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.trim().length > 0;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                //disables submit if blank
                decoration:
                    InputDecoration.collapsed(hintText: 'TYPE A MESSAGE'),
                //TODO see if you can get this to stay while the textbox is blank
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController
                        .text) //disables button when  blank/whitespace AND makes button colour unavailable
                    : null,
              ),
              // child: CupertinoButton( //idk if i want to localise for ios or not or if i want the app to look more or less the same across os's but here's an option
              //   child: Text('Send'),
              //   // icon: const Icon(Icons.send),
              //   onPressed: _isComposing
              //       ? () => _handleSubmitted(_textController
              //       .text) //disables button when  blank/whitespace AND makes button colour unavailable
              //       : null,
              // ),
            )
          ])),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    Message message = Message(
        text: text,
        timestamp: new DateTime.now(),
        animationController: AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: this,
        ));

    setState(() {
      _messages.insert(0, message);
    });

    _focusNode.requestFocus();

    message.animationController.forward();
  }
}
