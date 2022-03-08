import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  MessagingBloc? messagingBloc;

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _inputNotEmpty = false;

  @override
  void initState() {
    messagingBloc = BlocProvider.of<MessagingBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            Flexible(
              child: TextField(
                textInputAction: TextInputAction.go,
                //can customise what key sends here i think, anyway you could set a toggle for enter to send/enter to newline
                maxLines: null,
                controller: textEditingController,
                onChanged: (String text) {
                  setState(() {
                    //TODO ok putting a pin in this, probably i should put it in the bloc but clearly i STILL DON'T GET IT
                    _inputNotEmpty = text.trim().isNotEmpty;
                  });
                },
                onSubmitted: sendMessage,
                //disables submit if blank
                decoration:
                    const InputDecoration.collapsed(hintText: 'TYPE A MESSAGE'),
                //TODO see if you can get this to stay while the textbox is blank
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _inputNotEmpty
                    ? () => sendMessage(textEditingController
                        .text) //disables button when  blank/whitespace AND makes button colour unavailable
                    : null,
              ),
              //cupertino:see below
            )
          ])),
    ));
  }

  // void compose(context) {
  //   BlocProvider.of<MessagingBloc>(context)
  //       .add
  //       .MessageContentAdded(textEditingController.text);
  // }

  void sendMessage(context) {
    if (textEditingController.text.trim().isNotEmpty) {
      BlocProvider.of<MessagingBloc>(context).add(SendMessage(textEditingController
          .text)); //not trimming so u can have long spaces at the end of messages if YOU WANT TO. FORMATTING ANARCHY
      textEditingController.clear();
      _focusNode.requestFocus();
    }
    return;

    BlocProvider.of<MessagingBloc>(context)
        .add(MessageContentAdded(textEditingController.text));

    // message.animationController.forward(); //i think this needs to go in the bloc
  }
}

//cupertino:
// child: CupertinoButton( //idk if i want to localise for ios or not or if i want the app to look more or less the same across os's but here's an option
//   child: Text('Send'),
//   // icon: const Icon(Icons.send),
//   onPressed: _isComposing
//       ? () => _handleSubmitted(_textController
//       .text) //disables button when  blank/whitespace AND makes button colour unavailable
//       : null,
// ),
