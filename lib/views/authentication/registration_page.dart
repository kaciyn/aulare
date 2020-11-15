import 'dart:io';

import 'package:aulare/config/assets.dart';
import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/username_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage();

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();

}


class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  _RegistrationPageState();

  AuthenticationBloc authenticationBloc;

  final _picker = ImagePicker();
  File profilePictureFile;
  ImageProvider profilePicture;

  final TextEditingController usernameController = TextEditingController();
  AnimationController usernameFieldAnimationController;
  Animation profilePictureHeightAnimation, usernameAnimation;
  FocusNode usernameFocusNode = FocusNode();

  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    usernameFieldAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300));

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


    super.initState();


    @override
    void dispose() {
      WidgetsBinding.instance.removeObserver(this);
      usernameFieldAnimationController.dispose();
      usernameFocusNode.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          profilePicture = Image
              .asset(Assets.user)
              .image;
          if (state is DataPrefilled) {
            profilePicture = Image
                .network(state.user.profilePictureUrl)
                .image;
          } else if (state is ProfilePictureReceived) {
            profilePictureFile = state.file;
            profilePicture = Image
                .file(profilePictureFile)
                .image;
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
    );
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

  Future pickProfilePicture() async {
    final pickedProfilePictureFile =
    await _picker.getImage(source: ImageSource.gallery);
    profilePictureFile = File(pickedProfilePictureFile.path);
    authenticationBloc.add(PickedProfilePicture(profilePictureFile));
  }

  AnimatedOpacity updateProfileButton() {
    return AnimatedOpacity(
      // opacity: currentPage == 1 ? 1.0 : 0.0,
      //shows only on page 1
        duration: const Duration(milliseconds: 500),
        child: Container(
            margin: const EdgeInsets.only(right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () =>
                      authenticationBloc.add(
                          SaveProfile(
                              profilePictureFile, usernameController.text)),
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
