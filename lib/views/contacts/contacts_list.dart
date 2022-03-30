import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/default_theme.dart';
import '../../models/contact.dart';
import 'add_contact_dialogue.dart';
import 'components/alphabet_scroll_bar.dart';
import 'components/contact_row.dart';
import 'components/floating_add_button.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    List<Contact>? contacts;

    return BlocListener<ContactsBloc, ContactsState>(
      listener: (context, state) {
        if (state is Initial) {
          contacts = [];
        }
        if (state is ContactSuccessfullyAdded) {
          Navigator.pop(context);
          const snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Contact Added!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is Error) {
          final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(state.exception.errorMessage()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is AddContactFailed) {
          Navigator.pop(context);
          final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(state.exception.errorMessage()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: BlocProvider(
        create: (context) {
          return ContactsBloc(
            userDataRepository:
                RepositoryProvider.of<UserDataRepository>(context),
            messagingRepository:
                RepositoryProvider.of<MessagingRepository>(context),
          );
        },
// child: SafeArea(
        child: Scaffold(
            backgroundColor: darkTheme.scaffoldBackgroundColor,
            body: Stack(
              children: const <Widget>[
                ContactsScrollView(),
              ],
            ),
            floatingActionButton: FloatingAddButton(
                child: const Icon(Icons.add),
// animation: animation,
// vsync: this,
                onPressed: () => showAddContactBottomSheet(context))),
      ),
    );
  }
}
//NON BOTTOMSHEET VERSION
//       child: Form(
//         child: Container(
//           margin: const EdgeInsets.only(top: 100, right: 30, left: 30),
//           child: SafeArea(
//             child: Wrap(
//               alignment: WrapAlignment.center,
//               // child: Column(
//               //   crossAxisAlignment: CrossAxisAlignment.center,
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 120,
//                   child: Container(
//                     margin:
//                         const EdgeInsets.only(bottom: 20, right: 30, left: 30),
//                   ),
//                 ),
//                 const ContactUsernameInput(),
//                 const AddContactButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ContactsScrollView extends StatefulWidget {
  const ContactsScrollView({
    Key? key,
    this.contacts,
  }) : super(key: key);

  final List<Contact>? contacts;

  @override
  State<StatefulWidget> createState() => _ContactsScrollViewState();
}

class _ContactsScrollViewState extends State<ContactsScrollView>
    with TickerProviderStateMixin {
  late ContactsBloc contactsBloc;
  List<Contact>? contacts;

  final TextEditingController usernameInputController = TextEditingController();

  ScrollController? scrollController;

  late AnimationController animationController;
  Animation<double>? animation;

  @override
  void initState() {
    contactsBloc = BlocProvider.of<ContactsBloc>(context);
    scrollController = ScrollController();
    scrollController!.addListener(scrollListener);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
    animationController.forward();
    contactsBloc.add(FetchContacts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CustomScrollView(
        controller: scrollController,
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
                'Contacts',
              ),
            ),
          ),
          const UserContactsList(),
        ],
      ),
      ContactsScroll(contacts: contacts, scrollController: scrollController)
    ]);
  }

//scroll listener for checking scroll direction and hide/show fab
  void scrollListener() {
    if (scrollController!.position.userScrollDirection ==
        ScrollDirection.forward) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }
}

class ContactsScroll extends StatelessWidget {
  const ContactsScroll({
    Key? key,
    required this.contacts,
    required this.scrollController,
  }) : super(key: key);

  final List<Contact>? contacts;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 190),
      child:
          BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
        return AlphabetScrollBar(
          nameList: contacts,
          scrollController: scrollController,
        );
      }),
    );
  }
}

class UserContactsList extends StatelessWidget {
  const UserContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Contact>? contacts;

    return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
      if (state is FetchingContacts) {
        return SliverToBoxAdapter(
          child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Center(child: CircularProgressIndicator())),
        );
      }
      if (state is ContactsFetched) {
        contacts = state.contacts;
      }
      if (contacts != null) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ContactRow(contact: contacts![index]);
          }, childCount: contacts?.length),
        );
      } else {
        return SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Center(child: Text('NO CONTACTS ADDED YET'))));
      }
    });
  }
}
