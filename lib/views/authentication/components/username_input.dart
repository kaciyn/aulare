import 'package:aulare/config/defaultTheme.dart';
import 'package:flutter/material.dart';

class UsernameInput extends StatelessWidget {
  const UsernameInput({
    Key? key,
    required this.usernameFocusNode,
    required this.usernameController,
  }) : super(key: key);

  final FocusNode usernameFocusNode;
  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        width: 120,
        child: TextField(
          textAlign: TextAlign.center,
          // style: Styles.subHeadingLight,
          focusNode: usernameFocusNode,
          controller: usernameController,
          decoration: InputDecoration(
            hintText: '@username',
            // hintStyle: Styles.hintTextLight,
            contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: darkTheme.primaryColor, width: 0.1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: darkTheme.primaryColor, width: 0.1),
            ),
          ),
        ));
  }
}
