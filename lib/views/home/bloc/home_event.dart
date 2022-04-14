part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class FetchConversations extends HomeEvent {
  @override
  String toString() => 'FetchConversations';
}

class ReceiveConversationInfo extends HomeEvent {
  const ReceiveConversationInfo(this.conversationInfos);
  final List<Conversation> conversationInfos;

  @override
  String toString() => 'ReceiveConversationInfos';
}

class NavigatedTo extends HomeEvent {
  @override
  String toString() => 'NavigatedTo';
}
