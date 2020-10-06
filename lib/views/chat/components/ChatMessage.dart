import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String _name =
    'user'; //retrieve sender's name here later through authentication

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.timestamp, this.animationController});

  final DateTime timestamp;
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          //gives highest position along y axis since it's in a row (the other axis)
          children: [
            UserAvatar(),
            MessageContents(text: text, timestamp: timestamp),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //user icon
      margin: const EdgeInsets.all(10),
      child: CircleAvatar(//make this a random colour later that pulls from the user profile/an actual user avatar
          backgroundColor: Colors.cyan, radius: 10, child: Text(_name[0])),
    );
  }
}

class MessageContents extends StatelessWidget {
  const MessageContents({
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
          Text(timestamp.toLocal().toString(), style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }
}
