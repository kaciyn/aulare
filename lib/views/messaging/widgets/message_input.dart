import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController textEditingController =
      new TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            Flexible(
              child: TextField(
                textInputAction: TextInputAction.go,
                //can customise what key sends here i think, anyway you could set a toggle for enter to send/enter to newline
                maxLines: null,
                controller: textEditingController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.trim().isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? sendMessage : null,
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
                    ? () => sendMessage(textEditingController
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
    ));
  }

  void sendMessage(context) {
    BlocProvider.of<MessagingBloc>(context)
        .add(SendMessage(textEditingController.text));
    textEditingController.clear();
  }

  // void _submit(String text) {
  //   textEditingController.clear();
  //   setState(() {
  //     _isComposing = false;
  //   });
  //
  //   var message = Message(text, DateTime.now(), 'me', 'meee');
  //
  //   _focusNode.requestFocus();
  //
  //   message.animationController.forward();
  // }
}
