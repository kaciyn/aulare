part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({this.uid = '', this.username = ''});

  final String username;
  final String uid;

  AccountState copyWith({required String username, required String uid}) {
    return AccountState(
      username: username,
      uid: uid,
    );
  } //i'm going to fucking throw something

  @override
  List<Object> get props => [username, uid];

  @override
  String toString() => 'AccountState';
}

class AccountInitial extends AccountState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AccountInitial';
}

class CurrentUserDataFetched extends AccountState {
  @override
  List<Object> get props => [username, uid];

  @override
  String toString() => 'CurrentUserDataFetched';
}
