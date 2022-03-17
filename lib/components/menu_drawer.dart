import 'package:aulare/config/default_theme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/contacts/components/floating_add_button.dart';
import 'package:aulare/views/contacts/contacts_page.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:aulare/views/home/components/conversation_row.dart';
import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../views/authentication/bloc/authentication_bloc.dart';
import '../views/home/components/action_button.dart';
import '../views/home/components/expandable_floating_action_button.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: darkTheme.primaryColor,
            ),
            child: const Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.message),
            title: Text('MESSAGES'),
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('CONTACTS'),
            onTap: () => Navigator.push(
                context, SlideLeftRoute(page: const ContactListPage())),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('ACCOUNT'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('SETTINGS'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LOG OUT'),
            onTap: () {
              context.read<AuthenticationBloc>().add(Logout());
            },
          ),
        ],
      ),
    );
  }
}
