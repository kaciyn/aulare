import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState();

  AuthenticationBloc authenticationBloc;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
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
            title: const Text('Log In'),
          ),
          body: Form(
            child: Container(
              margin: const EdgeInsets.only(top: 100, right: 30, left: 30),
              child: Flexible(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 20, right: 30, left: 30),
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(UsernameInputActivated());
                      },
                      decoration:
                          const InputDecoration(labelText: 'Enter username'),
                      controller: _usernameController,
                    ),
                    TextFormField(
                      onTap: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(PasswordInputActivated());
                      },
                      decoration:
                          const InputDecoration(labelText: 'Enter password'),
                      controller: _passwordController,
                      obscureText: true,
                      // obscureText: state is PasswordObscured,
                      // decoration: InputDecoration(
                      //   hintText: 'Password',
                      //   suffix: Icon(Icons.visibility),
                      // ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            const EdgeInsets.only(top: 30, right: 10, left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: darkTheme.colorScheme.secondary)),
                        child: TextButton(
                            onPressed: state is! Authenticating
                                ? _onLoginButtonPressed
                                : null,
                            child: const Text('Login',
                                style: TextStyle(
                                    // color: darkTheme.primaryTextColorLight,
                                    fontWeight: FontWeight.w800))),
                      ),
                    ),
                    Container(
                      child: state is Authenticating
                          ? const CircularProgressIndicator()
                          : null,
                    ),
                  ],
                ),
              ),
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

  void _onLoginButtonPressed() {
    authenticationBloc.add(Login(
      username: _usernameController.text,
      password: _passwordController.text,
    ));

    Navigator.push(
      context,
      SlideLeftRoute(page: const HomePage()),
    );
  }
}
