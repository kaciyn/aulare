part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

// Fetch the contacts from firebase
class GetCurrentUserData extends AccountEvent {
  @override
  String toString() => 'GetCurrentUserData';
}