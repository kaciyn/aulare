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

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Contact>? contacts = [];

    final TextEditingController usernameInputController = TextEditingController();

    ScrollController? scrollController;

    contacts = [];
    scrollController = ScrollController();
    scrollController!.addListener(scrollListener);
    // late AnimationController animationController= AnimationController(
    //   vsync: context,
    //   duration: const Duration(milliseconds: 300),
    // );
    // Animation<double>? animation=CurvedAnimation(
    //       parent: animationController,
    //       curve: Curves.linear,
    //     );
    // animationController =
    //   animation =    animationController.forward();
    //   contactsBloc.add(FetchContacts());
    //   super.initState();
    // }

    return BlocListener<ContactsBloc, ContactsState>(
      listener: (context, state) {
        // print(state);
        if (state is ContactSuccessfullyAdded) {
          Navigator.pop(context);
          const snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Contact Added Successfully!'));
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
        child: SafeArea(
            child: Scaffold(
              backgroundColor: darkTheme.backgroundColor,
              body: Stack(
                children: <Widget>[
                  CustomScrollView(controller: scrollController,
                      slivers:
                      <Widget>[
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
                        BlocBuilder<ContactsBloc, ContactsState>(
                            builder: (context, state) {
                          print(state);
                          if (state is FetchingContacts) {
                            return SliverToBoxAdapter(
                              child: Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: const Center(
                                      child: CircularProgressIndicator())),
                            );
                          }
                              if (state is ContactsFetched) {
                                contacts = state.contacts;
                              }
                              return SliverList(
                                delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return ContactRow(contact: contacts![index]);
                            }, childCount: contacts!.length),
                          );
                        })
                      ]),
                  Container(
                    margin: const EdgeInsets.only(top: 190),
                    child: BlocBuilder<ContactsBloc, ContactsState>(
                        builder: (context, state) {
                      return AlphabetScrollBar(
                        nameList: contacts,
                        scrollController: scrollController,
                      );
                    }),
                  ),
                ],
              ),
            )),
        floatingActionButton: FloatingAddButton(
          child: const Icon(Icons.add),
          animation: animation,
          vsync: this,
          onPressed: () => showAddContactsBottomSheet(context),
        ),
      ),
    );
  }

  Future<void> showAddContactsBottomSheet(parentContext) async {
    await showModalBottomSheetApp(
        context: context,
        builder: (BuildContext bc) {
          return BlocBuilder<ContactsBloc, ContactsState>(
              builder: (context, state) {
                return Container(
                  color: const Color(0xFF737373),
                  // This line set the transparent background
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 20,
                                    right: 20),
                                child: Image.asset(Assets.social)),
                            Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: const Text(
                                // ignore: prefer_const_constructors
                                'Add by Username',
                                // style: Styles.textHeading,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                              child: TextField(
                                controller: usernameInputController,
                                textAlign: TextAlign.center,
                                // style: Styles.subHeading,
                                decoration: Decorations.getInputDecoration(
                                  hint: '@username',
                                  context: context,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: BlocBuilder<ContactsBloc,
                                      ContactsState>(
                                      builder: (context, state) {
                                        return FloatingAddButton(
                                          elevation: 0.0,
                                          child: getButtonChild(state),
                                          onPressed: () {
                                            contactsBloc.add(AddContact(
                                                username:
                                                usernameInputController.text));
                                          },
                                        );
                                      }),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                );
              });
        });
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

//scroll listener for checking scroll direction and hide/show fab
  scrollListener() {
    if (scrollController!.position.userScrollDirection ==
        ScrollDirection.forward) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }
}}


class ContactssPage extends StatefulWidget {
  const ContactssPage();

  @override
  State<StatefulWidget> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with TickerProviderStateMixin {
  late ContactsBloc contactsBloc;
  List<Contact>? contacts;

  final TextEditingController usernameInputController = TextEditingController();

  ScrollController? scrollController;

  late AnimationController animationController;
  Animation<double>? animation;

  @override
  void initState() {
    contacts = [];
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
    @override
    void dispose() {
      animationController.dispose();
      super.dispose();
    }
  }
