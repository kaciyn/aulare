import 'package:flutter/material.dart';

String _name =
    'user'; //retrieve sender's name here later through authentication

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //user icon
      margin: const EdgeInsets.all(10),
      child: CircleAvatar(
          //make this a random colour later that pulls from the user profile/an actual user avatar
          backgroundColor: Colors.cyan,
          radius: 10,
          child: Text(_name[0])),
    );
  }
}
