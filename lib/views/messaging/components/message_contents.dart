import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageContentsWidget extends StatelessWidget {
  const MessageContentsWidget({
    Key key,
    @required this.text,
    this.timestamp,
  }) : super(key: key);

  final String text;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //makes message text wrap
      child: Column(
        //user name
        crossAxisAlignment: CrossAxisAlignment.start,
        //gives leftmost position on x axis since it's a column
        children: [
          Text(_name, style: Theme.of(context).textTheme.caption),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(text, style: Theme.of(context).textTheme.bodyText1),
          ),
          Text(
              DateFormat('kk:mm - dd-MM-yyyy')
                  .format(timestamp.toLocal())
                  .toString(),
              style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }
}
