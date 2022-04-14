import 'package:aulare/config/default_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/bloc/app_bloc.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(listener: (context, state) {
      if (state is Unauthenticated) {
        Navigator.pushNamed(context, '/authentication');
      }
    }, child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: darkTheme.primaryColor,
              ),
              child: const Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('MESSAGES'),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('CONTACTS'),
              onTap: () => Navigator.pushNamed(context, '/contacts'),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('ACCOUNT'),
              onTap: () => Navigator.pushNamed(context, '/account'),
            ),
            // const ListTile(
            //   leading: const Icon(Icons.settings),
            //   title: const Text('SETTINGS'),
            // ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LOG OUT'),
              onTap: () {
                context.read<AppBloc>().add(AppLogoutRequested());
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      );
    }));
  }
}
