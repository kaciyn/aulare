part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class Initial extends HomeState {}

class FetchingConversationInfos extends HomeState {
  @override
  String toString() => 'FetchingConversations';
}

class ConversationInfosFetched extends HomeState {
  final List<ConversationInfo> conversations;

  ConversationInfosFetched(this.conversations);

  @override
  String toString() => 'ConversationsFetched';
}
