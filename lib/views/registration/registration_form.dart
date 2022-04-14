import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../config/default_theme.dart';
import '../../router/navigation.dart';
import '../authentication/bloc/authentication_bloc.dart';
import 'bloc/registration_bloc.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.pushNamed(context, '/home');
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? 'Registration Failure')),
            );
        }
      },
      child: Form(
        child: Container(
          margin: const EdgeInsets.only(top: 30, right: 30, left: 30),
          height: MediaQuery.of(context).size.height * 1,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(
                //   flex: 3,
                //   fit: FlexFit.tight,
                //   child:
                SizedBox(
                  height: 140,
                  // Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 30, left: 30),
                    child: const SecurityTips(),
                  ),
                ),
                // ),
                // Flexible(flex: 2, fit: FlexFit.loose, child:
                UsernameInput(),
                // ),
                // const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                // Flexible(flex: 2, fit: FlexFit.loose, child:
                PasswordInput(),
                // ),
                // const Padding(padding: EdgeInsets.all(12)),
                // const ProgressIndicator(),
                // const Flexible(
                //     flex: 1, fit: FlexFit.loose, child:
                const RegisterButton()
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UsernameInput extends StatelessWidget {
  UsernameInput({Key? key}) : super(key: key);

  final TextEditingController inputController = TextEditingController();

//ideally this and the generator would be split up but i'm stupid and don't know how to make it use the same bloc
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        if (state is RandomUsernameGenerated) {
          inputController.text = state.username.value;
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible(
              //   flex: 3,
              //   fit: FlexFit.loose,
              //   child:
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.7,
                width: 300,
                height: 55,
                child: TextField(
                    controller: inputController,
                    key: const Key('RegistrationForm_usernameInput_textField'),
                    onTap: () => context
                        .read<RegistrationBloc>()
                        .add(UsernameInputActivated()),
                    onChanged: (username) {
                      context
                          .read<RegistrationBloc>()
                          .add(RegistrationUsernameChanged(username));
                    },
                    cursorColor: darkTheme.colorScheme.secondary,
                    decoration: InputDecoration(
                      labelText: 'CHOOSE A USERNAME',
                      labelStyle: const TextStyle(color: Color(0xffadadad)),
                      errorText:
                          state.username.invalid ? 'invalid username' : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: darkTheme.colorScheme.secondary),
                      ),
                    )),
              ),
              // ),

              //random username generation
              // Flexible(
              //   flex: 1,
              // fit: FlexFit.loose,
              // child:

              TextButton(
                  onPressed: () => context
                      .read<RegistrationBloc>()
                      .add(GenerateRandomUsername()),
                  child: SizedBox(
                      width: 300,
                      height: 20,
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            const EdgeInsets.only(top: 1, right: 10, left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: darkTheme.colorScheme.secondary)),
                        child: Text('GENERATE USERNAME',
                            style: TextStyle(
                                fontSize: 10,
                                color: darkTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w600)),
                      ))),
              // )
            ]);
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  PasswordInput({Key? key}) : super(key: key);
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        // buildWhen: (previous, current) {
        //   previous.password != current.password||previous.obscurePassword != current.obscurePassword;
        // },
        builder: (context, state) {
      bool obscurePassword;
      obscurePassword = state.obscurePassword!;
      if (state is TogglingPasswordObscurity) {
        obscurePassword = state.obscurePassword!;
      }
      if (state is RandomPassphraseGenerated) {
        inputController.text = state.password.value;
      }
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 60,
                  child: TextField(
                      controller: inputController,
                      obscureText: obscurePassword,
                      key:
                          const Key('RegistrationForm_passwordInput_textField'),
                      onTap: () => context
                          .read<RegistrationBloc>()
                          .add(PasswordInputActivated()),
                      onChanged: (password) => context
                          .read<RegistrationBloc>()
                          .add(RegistrationPasswordChanged(password)),
                      cursorColor: darkTheme.colorScheme.secondary,
                      decoration: InputDecoration(
                        labelText: 'CHOOSE A PASSWORD',
                        labelStyle: const TextStyle(color: Color(0xffadadad)),
                        errorText:
                            state.password.invalid ? 'invalid password' : null,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: darkTheme.colorScheme.secondary),
                        ),
                      )),
                ),
                //password obscurity toggle
                // Flexible(
                //   flex: 1,
                //   fit: FlexFit.loose,
                //   child:
                IconButton(
                    alignment: Alignment.center,
                    // padding: new EdgeInsets.all(0.0),
                    splashRadius: 12,
                    iconSize: 20,
                    onPressed: () => context
                        .read<RegistrationBloc>()
                        .add(TogglePasswordObscurity()),
                    icon: obscurePassword
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility)),
                // ),
              ],
            ),
            // ),
            //random username generation
            TextButton(
                onPressed: () => context
                    .read<RegistrationBloc>()
                    .add(GenerateRandomPassphrase()),
                child: SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.8,
                    // height: MediaQuery.of(context).size.height * 0.065,
                    width: 280,
                    height: 20,
                    child: Container(
                      alignment: Alignment.center,
                      // margin:
                      //     const EdgeInsets.only(top: 10, right: 10, left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: darkTheme.colorScheme.secondary)),
                      child: Text('GENERATE PASSPHRASE',
                          style: TextStyle(
                              fontSize: 10,
                              color: darkTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w600)),
                      // Text('PASSPHRASE',
                      //     style: TextStyle(
                      //         fontSize: 10,
                      //         color: darkTheme.colorScheme.secondary,
                      //         fontWeight: FontWeight.w600))
                    )))
          ]);
    });
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: 200,
                height: 44,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 1, right: 10, left: 10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: darkTheme.colorScheme.secondary)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: TextButton(
                        onPressed: state.status.isValidated
                            ? () {
                                context
                                    .read<RegistrationBloc>()
                                    .add(const RegistrationSubmitted());
                              }
                            : null,
                        child: Text('REGISTER',
                            style: TextStyle(
                                color: darkTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w800))),
                  ),
                ),
              );
      },
    );
  }
}

class SecurityTips extends StatelessWidget {
  const SecurityTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text securityHint = const Text('');
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
      if (state is UsernameInputActive) {
//make this fade in and out later
        securityHint = const Text(
            "Tip: Make sure your username can't be used to personally identify you. Try a random word from the dictionary instead of a variation on your name or existing username. Don't re-use an existing username.",
            style: TextStyle(
                height: 1.01,
                color: CupertinoColors.lightBackgroundGray,
                fontWeight: FontWeight.w300));
      } else if (state is PasswordInputActive) {
//make this fade in and out later
        securityHint = const Text(
//TODO later: Minimum password length: 10 characters
//TODO later: passphrase generator
            "Tip: Instead of using a difficult-to-remember password, try using a passphrase made up of several words. Don't re-use an existing password.",
            style: TextStyle(
                color: CupertinoColors.lightBackgroundGray,
                fontWeight: FontWeight.w300));
      } else {
//make this fade in and out later
        securityHint = const Text('REGISTER NEW USER');
      }
      return securityHint;
    });
// child: securityHint);
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
      return Container(
        child:
            state is Authenticating ? const CircularProgressIndicator() : null,
      );
    });
  }
}
