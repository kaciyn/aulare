part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

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

  const ConversationInfosFetched(this.conversations);
  final List<ConversationInfo> conversations;

  @override
  String toString() => 'ConversationsFetched';
}
