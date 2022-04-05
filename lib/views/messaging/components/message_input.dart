import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MessageInput extends StatelessWidget {
  MessageInput(this.conversationId, {Key? key}) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String conversationId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagingBloc, MessagingState>(
        builder: (context, state) {
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
                  onChanged: (messageContent) => context
                      .read<MessagingBloc>()
                      .add(MessageContentChanged(messageContent)),
                  //disables submit if blank
                  decoration: (state.messageContent.value != '')
                      ? const InputDecoration.collapsed(
                          hintText: 'TYPE A MESSAGE')
                      : const InputDecoration.collapsed(hintText: ''),
                  //TODO see if you can get this to stay while the textbox is blank
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: state.status.isValidated
                      ? () => {
                            context.read<MessagingBloc>().add(SendMessage(
                                textEditingController, conversationId))
                          }
                      : null,
                  //disables button when  blank/whitespace AND makes button colour unavailable
                ),
                //cupertino:see belowm
              )
            ])),
      ));
    });
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
