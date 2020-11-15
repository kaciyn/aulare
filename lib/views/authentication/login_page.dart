import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/authentication/components/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key, @required this.userDataRepository})
      : assert(userDataRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

  final UserDataRepository userDataRepository;
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState();

  AuthenticationBloc authenticationBloc;

  // UserDataRepository get _userRepository => widget.userDataRepository;

  @override
  void initState() {
    super.initState();

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: const LoginForm(),
    );
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }
}
