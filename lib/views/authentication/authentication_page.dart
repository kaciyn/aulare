import 'dart:io';

import 'package:aulare/components/circle_indicator.dart';
import 'package:aulare/config/assets.dart';
import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/authentication_button.dart';
import 'package:aulare/views/messaging/components/messaging_page_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'components/username_input.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthenticationPageState();
  }
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;
  var isKeyboardOpen =
      false; //this variable keeps track of the keyboard, when it's shown and when its hidden

  final _picker = ImagePicker();
  File profilePictureFile;
  ImageProvider profilePicture;
  final TextEditingController usernameController = TextEditingController();

  PageController pageController =
      PageController(); // this is the controller of the page. This is used to navigate back and forth between the pages

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  //Fields related to animating the layout and pushing widgets up when the focus is on the username field
  AnimationController usernameFieldAnimationController;
  Animation profilePictureHeightAnimation, usernameAnimation;
  FocusNode usernameFocusNode = FocusNode();
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    usernameFieldAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    profilePictureHeightAnimation =
        Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    usernameAnimation =
        Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        usernameFieldAnimationController.forward();
      } else {
        usernameFieldAnimationController.reverse();
      }
    });

    pageController.addListener(() {
      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.listen((state) {
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
          resizeToAvoidBottomPadding: false,
          //  avoids the bottom overflow warning when keyboard is shown
          body: SafeArea(
              child: Stack(
            children: <Widget>[
              page(),
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
          child:  Text('AULARE',
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 50,
              )))
    ]);
  }

  Container page() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
          darkTheme.scaffoldBackgroundColor,
          darkTheme.scaffoldBackgroundColor
        ])),
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) => updatePageNumber(page),
                  children: <Widget>[signInPage(), userRegistrationPage()]),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < 2; i++)
                      PageIndicatorDot(i == currentPage),
                  ],
                ),
              ),
              updateProfileButton()
            ]));
  }

  Column signInPage() {
    return Column(
      children: <Widget>[
        header(),
        Row(children: <Widget>[
          authenticationButton(
              'Log In',
              Icon(
                Icons.login,
                color: darkTheme.accentColor,
                size: 25,
              ),
              ClickedLogIn(),
              context),
          authenticationButton(
              'Sign Up',
              Icon(
                Icons.person_add_alt_1_outlined,
                color: darkTheme.accentColor,
                size: 25,
              ),
              ClickedRegister(),
              context)
        ])
      ],
    );
  }

  Container loginButton() {
    return Container(
        margin: const EdgeInsets.only(top: 100),
        child: FlatButton.icon(
            onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
                .add(ClickedLogIn()),
            color: Colors.transparent,
            icon: Image.asset(
              Assets.google_button,
              height: 25,
            ),
            label: const Text(
              'Sign In with Google',
              style: TextStyle(
                  // color: darkTheme.primaryTextColorLight,
                  fontWeight: FontWeight.w800),
            )));
  }

  // Container googleSignInButton() {
  //   return Container(
  //       margin: const EdgeInsets.only(top: 100),
  //       child: FlatButton.icon(
  //           onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
  //               .add(ClickedGoogleLogin()),
  //           color: Colors.transparent,
  //           icon: Image.asset(
  //             Assets.google_button,
  //             height: 25,
  //           ),
  //           label: const Text(
  //             'Sign In with Google',
  //             style: TextStyle(
  //                 // color: darkTheme.primaryTextColorLight,
  //                 fontWeight: FontWeight.w800),
  //           )));
  // }

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

  InkWell userRegistrationPage() {
    return InkWell(
        // to dismiss the keyboard when the user tabs out of the TextField
        onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
    }, child: Container(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          profilePicture = Image.asset(Assets.user).image;
          if (state is DataPrefilled) {
            profilePicture = Image.network(state.user.profilePictureUrl).image;
          } else if (state is ProfilePictureReceived) {
            profilePictureFile = state.file;
            profilePicture = Image.file(profilePictureFile).image;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: profilePictureHeightAnimation.value),
              profilePicturePicker(),
              SizedBox(
                height: usernameAnimation.value,
              ),
              const Text(
                'Choose a username',
              ),
              UsernameInput(
                  usernameFocusNode: usernameFocusNode,
                  usernameController: usernameController)
            ],
          );
        },
      ),
    ));
  }

  GestureDetector profilePicturePicker() {
    return GestureDetector(
      onTap: pickProfilePicture,
      child: CircleAvatar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.camera,
              color: Colors.white,
              size: 15,
            ),
            Text(
              'Set Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            )
          ],
        ),
        backgroundImage: profilePicture,
        radius: 60,
      ),
    );
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

  Future pickProfilePicture() async {
    final pickedProfilePictureFile =
        await _picker.getImage(source: ImageSource.gallery);
    profilePictureFile = File(pickedProfilePictureFile.path);
    authenticationBloc.add(PickedProfilePicture(profilePictureFile));
  }

  AnimatedOpacity updateProfileButton() {
    return AnimatedOpacity(
        opacity: currentPage == 1 ? 1.0 : 0.0,
        //shows only on page 1
        duration: const Duration(milliseconds: 500),
        child: Container(
            margin: const EdgeInsets.only(right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () => authenticationBloc.add(
                      SaveProfile(profilePictureFile, usernameController.text)),
                  elevation: 0,
                  backgroundColor: darkTheme.primaryColor,
                  child: Icon(
                    Icons.done,
                    color: darkTheme.accentColor,
                  ),
                )
              ],
            )));
  }

  ///
  /// This routine is invoked when the window metrics have changed.
  ///
  // @override
  // void didChangeMetrics() {
  //   final value = MediaQuery.of(context).viewInsets.bottom;
  //   if (value > 0) {
  //     if (isKeyboardOpen) {
  //       onKeyboardChanged(false);
  //     }
  //     isKeyboardOpen = false;
  //   } else {
  //     isKeyboardOpen = true;
  //     onKeyboardChanged(true);
  //   }
  // }

  // onKeyboardChanged(bool isVisible) {
  //   if (!isVisible) {
  //     FocusScope.of(context).requestFocus(FocusNode());
  //     usernameFieldAnimationController.reverse();
  //   }
  // }

  navigateToHome() {
    Navigator.push(
      context,
      SlideLeftRoute(page: const ConversationPageSlide()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    usernameFieldAnimationController.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }
}
