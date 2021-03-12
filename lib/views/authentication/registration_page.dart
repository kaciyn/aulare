import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/navigator/navigator_bloc.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage();

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  _RegistrationPageState();

  AuthenticationBloc authenticationBloc;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();
  AnimationController usernameFieldAnimationController,
      passwordFieldAnimationController;

  @override
  void initState() {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    super.initState();
  }

  @override
  Widget build(context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
          ),
          body: Form(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Choose a username'),
                  controller: _usernameController,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Choose a password'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100, right: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: darkTheme.accentColor)),
                  child: TextButton(
                      onPressed:
                          // state is! Authenticating?
                          _onRegisterButtonPressed,
                      // : null,
                      child: const Text('Register',
                          style: TextStyle(
                              // color: darkTheme.primaryTextColorLight,
                              fontWeight: FontWeight.w800))),
                ),
                Container(
                  child: state is Authenticating
                      ? const CircularProgressIndicator()
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _onRegisterButtonPressed() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    authenticationBloc.add(RegisterAndLogin(
      username: username,
      password: password,
    ));
    // authenticationBloc.add(SaveProfile(
    //   // profilePicture,
    //     _usernameController.text));
    // authenticationBloc.add(Login(
    //   username: username,
    //   password: password,
    // ));
    // BlocProvider.of<NavigatorBloc>(context).add(NavigateToHome());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
