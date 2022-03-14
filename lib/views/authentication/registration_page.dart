import 'package:aulare/config/default_theme.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/transitions.dart';
import '../../navigator/navigator_bloc.dart';
import '../home/home_page.dart';
// import 'package:sizes/sizes_helpers.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage();

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  _RegistrationPageState();

  late AuthenticationBloc authenticationBloc;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _passwordInputFocusNode = FocusNode();
  final _usernameInputFocusNode = FocusNode();

  final TextEditingController usernameController = TextEditingController();
  AnimationController? usernameFieldAnimationController,
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
            title: const Text('REGISTER'),
          ),
          body: buildRegisterForm(state, context),
        );
      },
    );
  }

  Form buildRegisterForm(AuthenticationState state, BuildContext context) {
    return Form(
      child: Container(
        margin: const EdgeInsets.only(top: 100, right: 30, left: 30),
        child: SafeArea(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 30, left: 30),
                    child: Builder(builder: (context) {
                      if (state is Unauthenticated) {
                        //make this fade in and out later
                        return const Text('REGISTER NEW USER',
                            style: TextStyle(
                                color: CupertinoColors.lightBackgroundGray,
                                fontWeight: FontWeight.w300));
                      } else if (state is UsernameInputActive) {
                        //make this fade in and out later
                        return const Text(
                            "Tip: Make sure your username can't be used to personally identify you. Try a random word from the dictionary instead of a variation on your name or existing username.",
                            style: TextStyle(
                                color: CupertinoColors.lightBackgroundGray,
                                fontWeight: FontWeight.w300));
                      } else if (state is PasswordInputActive) {
                        //make this fade in and out later
                        return const Text(
                            //TODO later: Minimum password length: 10 characters
                            //TODO later: passphrase generator
                            'Tip: Instead of using a difficult-to-remember password, try using a passphrase made up of several words.',
                            style: TextStyle(
                                color: CupertinoColors.lightBackgroundGray,
                                fontWeight: FontWeight.w300));
                      } else {
                        return Text(state.toString());
                      }
                    })),
              ),
              TextFormField(
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(UsernameInputActivated());
                },
                focusNode: _usernameInputFocusNode,
                decoration:
                    const InputDecoration(labelText: 'CHOOSE A USERNAME'),
                controller: _usernameController,
              ),
              TextFormField(
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(PasswordInputActivated());
                },
                focusNode: _passwordInputFocusNode,
                decoration:
                    const InputDecoration(labelText: 'CHOOSE A PASSWORD'),
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
                  margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: darkTheme.colorScheme.secondary)),
                  child: TextButton(
                      onPressed: state is! Authenticating
                          ? _onRegisterButtonPressed
                          : null,
                      child: const Text('REGISTER',
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
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      callback();
    });
  }

  void _onRegisterButtonPressed() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    authenticationBloc.add(Register(
      username: username,
      password: password,
    ));

    authenticationBloc.add(SaveProfile(
        // profilePicture,
        _usernameController.text));

    authenticationBloc.add(Login(
      username: username,
      password: password,
    ));

    Navigator.push(
      context,
      SlideLeftRoute(page: const HomePage()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
