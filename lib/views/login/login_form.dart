import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../config/default_theme.dart';
import '../authentication/bloc/authentication_bloc.dart';
import 'bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.pushNamed(context, '/home');
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Form(
        child: Container(
          margin: const EdgeInsets.only(top: 100, right: 30, left: 30),
          child: SafeArea(
            child: Wrap(
              alignment: WrapAlignment.center,
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 30, left: 30),
                  ),
                ),
                const UsernameInput(),
                const PasswordInput(),
                const LoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UsernameInput extends StatelessWidget {
  const UsernameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
            key: const Key('loginForm_usernameInput_textField'),
            onTap: () =>
                context.read<LoginBloc>().add(UsernameInputActivated()),
            onChanged: (username) =>
                context.read<LoginBloc>().add(LoginUsernameChanged(username)),
            cursorColor: darkTheme.colorScheme.secondary,
            decoration: InputDecoration(
              labelText: 'ENTER USERNAME',
              labelStyle: const TextStyle(color: Color(0xffadadad)),
              errorText: state.username.invalid ? 'invalid username' : null,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: darkTheme.colorScheme.secondary),
              ),
            ));
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onTap: () =>
                context.read<LoginBloc>().add(PasswordInputActivated()),
            onChanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
            cursorColor: darkTheme.colorScheme.secondary,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'ENTER PASSWORD',
              labelStyle: const TextStyle(color: Color(0xffadadad)),
              errorText: state.password.invalid ? 'invalid password' : null,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: darkTheme.colorScheme.secondary),
              ),
            ));
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: 200,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: darkTheme.colorScheme.secondary)),
                  child: state.status.isSubmissionInProgress
                      ? const ProgressIndicator()
                      // ? const CircularProgressIndicator()
                      : TextButton(
                          key: const Key('loginForm_continue_Button'),
                          onPressed: state.status.isValidated
                              ? () => {
                                    context
                                        .read<LoginBloc>()
                                        .add(const LoginSubmitted())
                                  }
                              : null,
                          child: Text('LOG IN',
                              style: TextStyle(
                                  color: darkTheme.colorScheme.secondary,
                                  fontWeight: FontWeight.w800))),
                ),
              );
      },
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Container(
        child:
            state is Authenticating ? const CircularProgressIndicator() : null,
      );
    });
  }
}

// class LoginButton extends StatelessWidget {
//   const LoginButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder: (context, state) {
//         return state.status.isSubmissionInProgress
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//                 key: const Key('loginForm_continue_raisedButton'),
//                 child: const Text('Login'),
//                 onPressed: state.status.isValidated
//                     ? () {
//                         context.read<LoginBloc>().add(const LoginSubmitted());
//                       }
//                     : null,
//               );
//       },
//     );
//   }
// }
// class LoginButton extends StatelessWidget {
//   const LoginButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder: (context, state) {
//         return state.status.isSubmissionInProgress
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//                 key: const Key('loginForm_continue_raisedButton'),
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   primary: const Color(0xFFFFD600),
//                 ),
//                 onPressed: state.status.isValidated
//                     ? () =>
//                         context.read<LoginBloc>().add(const LoginSubmitted())
//                     : null,
//                 child: const Text('LOGIN'),
//               );
//       },
//     );
//   }
// }
