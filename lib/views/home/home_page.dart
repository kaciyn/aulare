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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(context) {
    //for displaying user info etc
    // final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<AppBloc, AppState>(
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
                      //lets back button coexist with enddrawer
                      //only keep this for testing
                      // leading: (ModalRoute.of(context)?.canPop ?? false)
                      //     ? const BackButton()
                      //     : null,
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
                    const Conversations(),
                  ],
                ),
                floatingActionButton:
                    buildExpandableFloatingActionButton(context))));
  }
}

class Conversations extends StatelessWidget {
  const Conversations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Conversation>? conversationsInfo = <Conversation>[];

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is Initial) {
        context.read<HomeBloc>().add(FetchConversations());
      }
      if (state is FetchingConversationsInfo ||
          conversationsInfo == null ||
          conversationsInfo!.isEmpty) {
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
            (context, index) => ConversationRow(conversationsInfo![index]),
            childCount: conversationsInfo!.length),
      );
    });
  }
}

//this may need a refactor to stless but we'll see
ExpandableFloatingActionButton buildExpandableFloatingActionButton(
    BuildContext context) {
  return ExpandableFloatingActionButton(
    distance: 112.0,
    children: [
      ActionButton(
        onPressed: () => _showAction(context, 1),
        icon: const Icon(Icons.create),
        label: 'SEND MESSAGE',
      ),
      ActionButton(
        onPressed: () => showAddContactBottomSheet(context),
        icon: const Icon(Icons.person_add),
        label: 'ADD CONTACT',
      ),
      ActionButton(
        onPressed: () => _showAction(context, 2),
        icon: const Icon(Icons.group_add),
        label: 'GROUPS',
      ),
    ],
  );
}

void _showAction(BuildContext context, int index) {
  const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

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
