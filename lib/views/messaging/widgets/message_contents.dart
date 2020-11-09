import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'file:///D:/BigBadCodeRepos/aulare/lib/views/messaging/models/message.dart';

class MessageContentsWidget extends StatelessWidget {
  const MessageContentsWidget({
    Key key,
    @required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //makes message text wrap
      child: Column(
        //user name
        crossAxisAlignment: CrossAxisAlignment.start,
        //gives leftmost position on x axis since it's a column
        children: [
          Text(message.senderName, style: Theme.of(context).textTheme.caption),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(message.text,
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Text(
              DateFormat('kk:mm - dd-MM-yyyy')
                  .format(message.timestamp.toLocal())
                  .toString(),
              style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }
}
