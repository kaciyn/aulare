import 'package:aulare/views/registration/registration_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/default_theme.dart';
import '../authentication/bloc/authentication_repository.dart';
import 'bloc/registration_bloc.dart';
// import 'package:sizes/sizes_helpers.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RegistrationPage());
  }

  // class _RegistrationPageState extends State<RegistrationPage>
  // with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // _RegistrationPageState();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTER'),
        backgroundColor: const Color(0xff0D0D0D),
        elevation: 0,
      ),
      body: BlocProvider(
          create: (context) {
            return RegistrationBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: const RegistrationForm()),
    );
  }
}
