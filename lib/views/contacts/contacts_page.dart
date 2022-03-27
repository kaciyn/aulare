import 'package:aulare/views/contacts/contact_username_input.dart';
import 'package:aulare/components/modal_bottom_sheet_layout.dart';
import 'package:aulare/config/assets.dart';
import 'package:aulare/config/decorations.dart';
import 'package:aulare/config/default_theme.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/contacts/components/alphabet_scroll_bar.dart';
import 'package:aulare/views/contacts/components/contact_row.dart';
import 'package:aulare/views/contacts/components/floating_add_button.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:formz/formz.dart';

class ContactsPage extends StatelessWidget {
  ContactsPage({Key? key}) : super(key: key);

  static Page page() => MaterialPage<void>(child: ContactsPage());
  List<Contact>? contacts;

  @override
  Widget build(context) {
    return BlocListener<ContactsBloc, ContactsState>(
      listener: (context, state) {
        // print(state);
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
          );
        },
        // child: SafeArea(
        child: Scaffold(
            backgroundColor: darkTheme.backgroundColor,
            body: Stack(
              children: <Widget>[
                const ContactsScrollView(),
              ],
            ),
            floatingActionButton: FloatingAddButton(
                child: const Icon(Icons.add),
                // animation: animation,
                // vsync: this,
                onPressed: () => showAddContactsBottomSheet(context))),
      ),
      // ),
    );
  }
}

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
    // contactsBloc.add(FetchContacts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: darkTheme.backgroundColor,
            expandedHeight: 180.0,
            pinned: true,
            elevation: 0,
            centerTitle: true,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Contacts',
                // style: Styles.appBarTitle
              ),
            ),
          ),
          const ContactsList(),
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

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Contact>? contacts;

    return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
      // print(state);
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

Future<void> showAddContactsBottomSheet(context) async {
  await showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) {
          return Container(
            color: const Color(0xFF737373),
            // This line set the transparent background
            child: Container(
                decoration: BoxDecoration(
                    color: darkTheme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0))),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Padding(
                      //     padding: const EdgeInsets.only(left: 20, right: 20),
                      // child: Image.asset(Assets.social)),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: const Text(
                          // ignore: prefer_const_constructors
                          'ADD BY USERNAME',
                          // style: Styles.textHeading,
                        ),
                      ),
                      const ContactUsernameInput(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const <Widget>[
                          AddContactButton(),
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
      });
}

class AddContactButton extends StatelessWidget {
  const AddContactButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
      return FloatingAddButton(
        elevation: 0.0,
        child: getButtonChild(state),
        onPressed: state.status.isValidated
            ? () {
                context.read<ContactsBloc>().add(const AddContact());
              }
            : null,
      );
    });
  }
}

Widget getButtonChild(ContactsState state) {
  if (state is ContactSuccessfullyAdded || state is Error) {
    return Icon(Icons.check, color: darkTheme.primaryColor);
  } else if (state is AddingContact) {
    return const SizedBox(
      height: 9,
      width: 9,
      child: CircularProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  } else {
    return Icon(Icons.done, color: darkTheme.primaryColor);
  }
}
