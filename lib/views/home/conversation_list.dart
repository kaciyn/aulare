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

class ConversationList extends StatelessWidget {
  const ConversationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Conversation>? conversationsInfo = <Conversation>[];

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is Initial) {
        context.read<HomeBloc>().add(FetchConversations());
      }
      if (state is FetchingConversationsInfo) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: const [
                Center(child: Text('FETCHING CONVERSATIONS ')),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      }
      if (state.conversations == null || state.conversations!.isEmpty) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(child: Text('NO CONVERSATIONS YET')),
          ),
        );
      } else if (state is ConversationsInfoFetched &&
          state.conversations!.isNotEmpty) {
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
