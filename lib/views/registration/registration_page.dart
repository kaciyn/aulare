import 'dart:io';

import 'package:aulare/config/assets.dart';
import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/messaging/widgets/messaging_page_slide.dart';
import 'package:aulare/views/registration/bloc/authentication_bloc.dart';
import 'package:aulare/views/registration/circle_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;
  var isKeyboardOpen =
      false; //this variable keeps track of the keyboard, when it's shown and when its hidden

  final _picker = ImagePicker();
  File profileImageFile;
  ImageProvider profileImage;
  final TextEditingController usernameController = TextEditingController();

  PageController pageController =
      PageController(); // this is the controller of the page. This is used to navigate back and forth between the pages

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  //Fields related to animating the layout and pushing widgets up when the focus is on the username field
  AnimationController usernameFieldAnimationController;
  Animation profilePicHeightAnimation, usernameAnimation, ageAnimation;
  FocusNode usernameFocusNode = FocusNode();
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    usernameFieldAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    profilePicHeightAnimation =
        Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    usernameAnimation =
        Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    ageAnimation =
        Tween(begin: 80.0, end: 10.0).animate(usernameFieldAnimationController)
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
        updatePageState(1);
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
              buildHome(),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is Authenticating ||
                      state is ProfileUpdateInProgress) {
                    return buildCircularProgressBarWidget();
                  }
                  return const SizedBox();
                },
              )
            ],
          )),
        ));
  }

  buildHome() {
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
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) => updatePageState(page),
                  children: <Widget>[buildPageOne(), buildPageTwo()]),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < 2; i++)
                      CircleIndicator(i == currentPage),
                  ],
                ),
              ),
              buildUpdateProfileButtonWidget()
            ]));
  }

  buildCircularProgressBarWidget() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
          darkTheme.scaffoldBackgroundColor,
          darkTheme.scaffoldBackgroundColor,
        ])),
        child: Container(
            child: Center(
          child: Column(children: <Widget>[
            buildHeaderSectionWidget(),
            Container(
              margin: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(darkTheme.primaryColor)),
            )
          ]),
        )));
  }

  buildPageOne() {
    return Column(
      children: <Widget>[buildHeaderSectionWidget(), buildGoogleButtonWidget()],
    );
  }

  buildHeaderSectionWidget() {
    return Column(children: <Widget>[
      //TODO header image will go here later
      // Container(
      //     margin: EdgeInsets.only(top: 250),)
      //     child: Image.asset(Assets.app_icon_fg, height: 100)),
      Container(
          // margin: EdgeInsets.only(top: 30),
          margin: EdgeInsets.only(top: 280),
          child: Text('AULARE',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)))
    ]);
  }

  buildGoogleButtonWidget() {
    return Container(
        margin: EdgeInsets.only(top: 100),
        child: FlatButton.icon(
            onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
                .add(ClickedGoogleLogin()),
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

  buildPageTwo() {
    return InkWell(
        // to dismiss the keyboard when the user tabs out of the TextField
        onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
    }, child: Container(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          profileImage = Image.asset(Assets.user).image;
          if (state is DataPrefilled) {
            profileImage = Image.network(state.user.profileImageUrl).image;
          } else if (state is ProfilePictureReceived) {
            profileImageFile = state.file;
            profileImage = Image.file(profileImageFile).image;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: profilePicHeightAnimation.value),
              buildProfilePictureWidget(),
              SizedBox(
                height: ageAnimation.value,
              ),
              SizedBox(
                height: usernameAnimation.value,
              ),
              Text(
                'Choose a username',
              ),
              buildUsernameWidget()
            ],
          );
        },
      ),
    ));
  }

  buildProfilePictureWidget() {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
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
        backgroundImage: profileImage,
        radius: 60,
      ),
    );
  }

  Container buildUsernameWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        width: 120,
        child: TextField(
          textAlign: TextAlign.center,
          // style: Styles.subHeadingLight,
          focusNode: usernameFocusNode,
          controller: usernameController,
          decoration: InputDecoration(
            hintText: '@username',
            // hintStyle: Styles.hintTextLight,
            contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: darkTheme.primaryColor, width: 0.1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: darkTheme.primaryColor, width: 0.1),
            ),
          ),
        ));
  }

  void updatePageState(index) {
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

  Future pickImage() async {
    var pickedProfileImageFile =
        await _picker.getImage(source: ImageSource.gallery);
    profileImageFile = File(pickedProfileImageFile.path);
    authenticationBloc.add(PickedProfilePicture(profileImageFile));
  }

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

  AnimatedOpacity buildUpdateProfileButtonWidget() {
    return AnimatedOpacity(
        opacity: currentPage == 1 ? 1.0 : 0.0,
        //shows only on page 1
        duration: Duration(milliseconds: 500),
        child: Container(
            margin: EdgeInsets.only(right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () => authenticationBloc.add(
                      SaveProfile(profileImageFile, usernameController.text)),
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
  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (isKeyboardOpen) {
        onKeyboardChanged(false);
      }
      isKeyboardOpen = false;
    } else {
      isKeyboardOpen = true;
      onKeyboardChanged(true);
    }
  }

  onKeyboardChanged(bool isVisible) {
    if (!isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
      usernameFieldAnimationController.reverse();
    }
  }

  navigateToHome() {
    Navigator.push(
      context,
      SlideLeftRoute(page: ConversationPageSlide()),
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
