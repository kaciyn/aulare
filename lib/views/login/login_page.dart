import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/bloc/authentication_repository.dart';
import 'bloc/login_bloc.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //   builder: (context, state) {
    //     if (state is Failed) {
    //       _onWidgetDidBuild(() {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text(state.error),
    //             backgroundColor: Colors.red,
    //           ),
    //         );
    //       });
    //     }
    return Scaffold(
        appBar: AppBar(
          title: const Text('LOG IN'),
          backgroundColor: const Color(0xff0D0D0D),
          elevation: 0,
        ),
        body: BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: const LoginForm(),
        ));
  }
}

// void _onWidgetDidBuild(Function callback) {
//   WidgetsBinding.instance!.addPostFrameCallback((_) {
//     callback();
//   });
// }
