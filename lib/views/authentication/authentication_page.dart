import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/authentication_button.dart';
import 'package:aulare/views/authentication/login_page.dart';
import 'package:aulare/views/authentication/registration_page.dart';
import 'package:aulare/views/messaging/components/messaging_page_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage();

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with WidgetsBindingObserver {
  int currentPage = 0;
  var isKeyboardOpen =
      false; //this variable keeps track of the keyboard, when it's shown and when its hidden

  PageController pageController =
      PageController(); // this is the controller of the page. This is used to navigate back and forth between the pages

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  late AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.stream.listen((state) {
      if (state is Authenticated) {
        updatePageNumber(1);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop, //user to override the back button press
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          //  avoids the bottom overflow warning when keyboard is shown
          body: SafeArea(
              child: Stack(
            children: <Widget>[
              pageBody(),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is Authenticating ||
                      state is ProfileUpdateInProgress) {
                    return loadingProgressIndicator();
                  }
                  return const SizedBox();
                },
              )
            ],
          )),
        ));
  }

  Column header() {
    return Column(children: <Widget>[
      //TODO header image will go here later
      // Container(
      //     margin: EdgeInsets.only(top: 250),)
      //     child: Image.asset(Assets.app_icon_fg, height: 100)),
      Container(
          // margin: EdgeInsets.only(top: 30),
          margin: const EdgeInsets.only(top: 280),
          child: Text('AULARE',
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 50,
              )))
    ]);
  }

  Container pageBody() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
          darkTheme.scaffoldBackgroundColor,
          darkTheme.scaffoldBackgroundColor
        ])),
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Column(
                children: <Widget>[
                  header(),
                  Row(children: <Widget>[
                    authenticationButton(
                        'Log In',
                        Icon(
                          Icons.login,
                          color: darkTheme.colorScheme.secondary,
                          size: 25,
                        ),
                        const LoginPage(),
                        context),
                    authenticationButton(
                        'Sign Up',
                        Icon(
                          Icons.person_add_alt_1_outlined,
                          color: darkTheme.colorScheme.secondary,
                          size: 25,
                        ),
                        const RegistrationPage(),
                        context)
                  ])
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ]));
  }

  Container loadingProgressIndicator() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
          darkTheme.scaffoldBackgroundColor,
          darkTheme.scaffoldBackgroundColor,
        ])),
        child: Container(
            child: Center(
          child: Column(children: <Widget>[
            header(),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(darkTheme.primaryColor)),
            )
          ]),
        )));
  }

  void updatePageNumber(index) {
    if (currentPage == index) {
      return;
    }

    if (index == 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }

    setState(() {
      currentPage = index;
    });
  }

  void navigateToHome() {
    Navigator.push(
      context,
      SlideLeftRoute(page: const ConversationPageSlide()),
    );
  }

  @override
  Future<bool> onWillPop() {
    if (currentPage == 1) {
      //go to first page if currently on second page
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
