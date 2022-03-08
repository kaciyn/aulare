import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/contacts/components/floating_add_button.dart';
import 'package:aulare/views/contacts/contacts_page.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:aulare/views/home/components/conversation_row.dart';
import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    var conversationInfos = <ConversationInfo>[];
    homeBloc.add(FetchConversations());

    return SafeArea(
        child: Scaffold(
            backgroundColor: darkTheme.scaffoldBackgroundColor,
            endDrawer: Drawer(
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
                ],
              ),
            ),
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                //lets back button coexist with enddrawer
                leading: (ModalRoute.of(context)?.canPop ?? false)
                    ? const BackButton()
                    : null,
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
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state is FetchingConversationsInfo) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(child: Text('NO CONVERSATIONS YET')),
                      // child: const Center(child: CircularProgressIndicator()),
                    ),
                  );
                } else if (state is ConversationsInfoFetched) {
                  conversationInfos = state.conversations;
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ConversationRow(conversationInfos[index]),
                      childCount: conversationInfos.length),
                );
              })
            ]),
            floatingActionButton: FloatingAddButton(
              child: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                  context, SlideLeftRoute(page: const ContactListPage())),
            )));
  }
}
