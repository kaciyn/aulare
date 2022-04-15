import 'package:aulare/views/messaging/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    Key? key,
    required this.message,
    // required this.contact,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    //expanded makes message text wrap
    return Container(
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Align(
            alignment:
                message.isFromSelf ? Alignment.topRight : Alignment.topLeft,
            // children: [
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.6),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: message.isFromSelf
                      ? const Color(0xff00222f)
                      : Colors.grey.shade900,
                ),
                child: Column(
                  //user name
                  // crossAxisAlignment:
                  //gives leftmost position on x axis since it's a column
                  children: [
                    // Text(message.senderUsername,
                    //     style: Theme.of(context).textTheme.caption),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(message.text!,
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            DateFormat('HH:mm dd/MM/yyyy')
                                .format(message.timestamp.toLocal())
                                .toString(),
                            style: Theme.of(context).textTheme.labelSmall),
                      ),
                    )
                  ],
                ),
              ),
            )
            // ],
            ));
  }
}
