import 'package:aulare/components/menu_drawer.dart';
import 'package:aulare/config/default_theme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/contacts/components/floating_add_button.dart';
import 'package:aulare/views/contacts/contacts_page.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:aulare/views/home/components/conversation_row.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../contacts/add_contact_dialogue.dart';
import '../messaging/bloc/messaging_repository.dart';
import 'components/action_button.dart';
import 'components/expandable_floating_action_button.dart';
import 'conversation_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pushNamed(context, '/home');
        //disables the thing where the back button would return you to the registration page without logging you out or anything
        return true;
      },
      child: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              Navigator.pushNamed(context, '/authentication');
            }
          },
          child: BlocProvider(
              create: (context) {
                return HomeBloc(
                  messagingRepository:
                      RepositoryProvider.of<MessagingRepository>(context),
                );
              },
              child: Scaffold(
                  backgroundColor: darkTheme.scaffoldBackgroundColor,
                  endDrawer: const MenuDrawer(),
                  body: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor: darkTheme.scaffoldBackgroundColor,
                        expandedHeight: 180.0,
                        pinned: true,
                        elevation: 0,
                        centerTitle: true,
                        flexibleSpace: const FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            'CONVERSATIONS',
                          ),
                        ),
                      ),
                      const ConversationList(),
                    ],
                  ),
                  floatingActionButton:
                      buildExpandableFloatingActionButton(context)))),
    );
  }
}

//this may need a refactor to stless but we'll see
ExpandableFloatingActionButton buildExpandableFloatingActionButton(
    BuildContext context) {
  return ExpandableFloatingActionButton(
    distance: 112.0,
    children: [
      ActionButton(
        onPressed: () => Navigator.pushNamed(context, '/contacts'),
        icon: const Icon(Icons.create),
        label: 'SEND MESSAGE',
      ),
      ActionButton(
        onPressed: () => showAddContactBottomSheet(context),
        icon: const Icon(Icons.person_add),
        label: 'ADD CONTACT',
      ),
      // ActionButton(
      //   onPressed: () => Navigator.pushNamed(context, '/contacts'),
      //   icon: const Icon(Icons.contacts),
      //   label: 'CONTACTS',
      // ),
    ],
  );
}
