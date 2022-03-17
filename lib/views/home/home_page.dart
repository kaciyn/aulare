import 'package:aulare/components/menu_drawer.dart';
import 'package:aulare/config/default_theme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/contacts/components/floating_add_button.dart';
import 'package:aulare/views/contacts/contacts_page.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:aulare/views/home/components/conversation_row.dart';
import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/action_button.dart';
import 'components/expandable_floating_action_button.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  static Page page() => const MaterialPage<void>(child: HomePage());

  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    List<ConversationInfo>? conversationsInfo = <ConversationInfo>[];
    homeBloc.add(FetchConversations());

    return SafeArea(
        child: Scaffold(
            backgroundColor: darkTheme.scaffoldBackgroundColor,
            endDrawer: MenuDrawer(context: context),
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
                  conversationsInfo = state.conversations;
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ConversationRow(conversationsInfo![index]),
                      childCount: conversationsInfo!.length),
                );
              })
            ]),
            floatingActionButton:
                buildExpandableFloatingActionButton(context)));
  }

  ExpandableFloatingActionButton buildExpandableFloatingActionButton(
      BuildContext context) {
    return ExpandableFloatingActionButton(
      distance: 112.0,
      children: [
        ActionButton(
          onPressed: () => Navigator.push(
              context, SlideLeftRoute(page: const ContactListPage())),
          icon: const Icon(Icons.create),
        ),
        ActionButton(
          onPressed: () => Navigator.push(
              context, SlideLeftRoute(page: const ContactListPage())),
          icon: const Icon(Icons.person_add),
        ),
        ActionButton(
          onPressed: () => _showAction(context, 2),
          icon: const Icon(Icons.group_add),
        ),
      ],
    );
  }

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }
}
