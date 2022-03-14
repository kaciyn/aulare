import 'package:flutter/material.dart';

import '../../components/menu_drawer.dart';
import '../../config/default_theme.dart';
import '../../config/transitions.dart';
import '../contacts/contacts_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: darkTheme.scaffoldBackgroundColor,
            endDrawer: MenuDrawer(context: context),
            body: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'ACCOUNT',
              ),
            )));
  }
}
