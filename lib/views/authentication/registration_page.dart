import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/home/home_page.dart';
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
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Failed) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
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
    authenticationBloc.add(Register(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
    Navigator.push(
      context,
      SlideLeftRoute(page: HomePage()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}