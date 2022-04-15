import 'package:aulare/app/bloc/app_bloc.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/views/account/bloc/account_bloc.dart';
import 'package:aulare/views/authentication/bloc/authentication_repository.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/menu_drawer.dart';
import '../../config/default_theme.dart';
import 'package:flutter/material.dart';

import '../../repositories/user_data_repository.dart';
import '../../utilities/shared_objects.dart';
import '../messaging/bloc/messaging_repository.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ACCOUNT'),
          backgroundColor: const Color(0xff0D0D0D),
          elevation: 0,
        ),
        backgroundColor: darkTheme.scaffoldBackgroundColor,
        endDrawer: const MenuDrawer(),
        body: BlocProvider(
            create: (context) {
              return AccountBloc(
                  authenticationRepository:
                      RepositoryProvider.of<AuthenticationRepository>(context));
            },
            child: const UserInfo()));
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AccountBloc>().add(GetCurrentUserData());
    return BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
      if (state is AccountInitial) {
        context.read<AccountBloc>().add(GetCurrentUserData());
      }
      // if (state is CurrentUserDataFetched) {
      if (state.username != null && state.uid != null) {
        var empty = '';
        String? username = state.username;
        String? uid = state.uid;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('USERNAME: $username'),
            Text(
                'SESSIONUSERNAME: ${SharedObjects.preferences.getString(Constants.sessionUsername)}'),
            Text('UID: $uid'),
            Text(
                'SESSIONUSERID: ${SharedObjects.preferences.getString(Constants.sessionUserId)}'),
            // LoginStatus()
          ],
        );
      } else {
        return Column(
            children: const [Text('CURRENT USER IS NULL'), LoginStatus()]);
      }
    });
    // else {
    //   return Text(
    //       'SOMETHING HAS GONE TERRIBLY WRONG - STATE IS: ${state.toString()}');
    // }
  }
}

class LoginStatus extends StatelessWidget {
  const LoginStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state is Authenticated) {
        return const Text('APP STATE IS AUTHENTICATED');
      } else if (state is Unauthenticated) {
        return const Text('APP STATE IS UNAUTHENTICATED');
      } else {
        final stateString = state.toString();
        return Text('APP STATE IS:$stateString');
      }
    });
  }
}
