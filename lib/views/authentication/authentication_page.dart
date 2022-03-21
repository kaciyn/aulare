import 'package:aulare/config/default_theme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/authentication_button.dart';
import 'package:aulare/views/login/login_page.dart';
import 'package:aulare/views/registration/registration_page.dart';
import 'package:aulare/views/messaging/components/messaging_page_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage();

  static Page page() => const MaterialPage<void>(child: AuthenticationPage());

// @override
// _AuthenticationPageState createState() => _AuthenticationPageState();

// class _AuthenticationPageState extends State<AuthenticationPage>
//     with WidgetsBindingObserver {
//this variable keeps track of the keyboard, when it's shown and when its hidden
//
// PageController pageController =
//     PageController(); // this is the controller of the page. This is used to navigate back and forth between the pages
//

// @override
// void initState() {
//   WidgetsBinding.instance!.addObserver(this);
//
//   authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
//   authenticationBloc.stream.listen((state) {
//     if (state is Authenticated) {
//       updatePageNumber(1);
//     }
//   });
//
//   super.initState();
// }

  @override
  Widget build(BuildContext context) {
    // final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    // int currentPage = 0;
    // var isKeyboardOpen = false;

    return
      // WillPopScope(
      // onWillPop: onWillPop, //user to override the back button press
      // child:
      Scaffold(
          resizeToAvoidBottomInset: false,
          //  avoids the bottom overflow warning when keyboard is shown
          body: SafeArea(
              child: Stack(children: <Widget>[
                buildPageBody(context),
                // BlocBuilder<AuthenticationBloc, AuthenticationState>(
                //   builder: (context, state) {
                //     if (state is Authenticating || state is ProfileUpdateInProgress) {
                //       return buildLoadingProgressIndicator(context);
                //     }
                //     return const SizedBox();
                //   },
              ])));
  }

  Column buildHeader(BuildContext context) {
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

  Container buildPageBody(BuildContext context) {
    // //Fields related to animation of the gradient
    const Alignment begin = Alignment.center;
    const Alignment end = Alignment.bottomRight;

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
                  buildHeader(context),
                  Row(children: <Widget>[
                    authenticationButton(
                        'LOG IN',
                        Icon(
                          Icons.login,
                          color: darkTheme.colorScheme.secondary,
                          size: 25,
                        ),
                        const LoginPage(),
                        context),
                    authenticationButton(
                        'SIGN UP',
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

  Container buildLoadingProgressIndicator(BuildContext context) {
    const Alignment begin = Alignment.center;
    const Alignment end = Alignment.bottomRight;
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
              darkTheme.scaffoldBackgroundColor,
              darkTheme.scaffoldBackgroundColor,
            ])),
        child: Container(
            child: Center(
              child: Column(children: <Widget>[
                buildHeader(context),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(darkTheme.primaryColor)),
                )
              ]),
            )));
  }

// void updatePageNumber(index) {
//   if (currentPage == index) {
//     return;
//   }
//
//   if (index == 1) {
//     pageController.nextPage(
//         duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
//   }
//
//   setState(() {
//     currentPage = index;
//   });
// }

// void navigateToHome() {
//   Navigator.push(
//     context,
//     SlideLeftRoute(page: const ConversationPageSlide()),
//   );
// }

// @override
// Future<bool> onWillPop() {
//   if (currentPage == 1) {
//     //go to first page if currently on second page
//     pageController.previousPage(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//     return Future.value(false);
//   }
//   return Future.value(true);
// }

// @override
// void dispose() {
//   WidgetsBinding.instance!.removeObserver(this);
//   super.dispose();
// }
}
