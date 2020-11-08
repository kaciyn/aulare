import 'package:aulare/config/defaultTheme.dart';
import 'package:flutter/material.dart';

class ContactRow extends StatelessWidget {
  const ContactRow({
    Key key,
    @required this.name,
  }) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: darkTheme.backgroundColor,
        child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(text: "${name.toString().split(' ')[0]} "),
                  TextSpan(
                      text: name.toString().split(' ')[1],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )));
  }
}
