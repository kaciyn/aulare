part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class FetchConversations extends HomeEvent {
  @override
  String toString() => 'FetchConversations';
}

class ReceiveConversationInfos extends HomeEvent {

  const ReceiveConversationInfos(this.conversationInfos);
  final List<ConversationInfo> conversationInfos;

  @override
  String toString() => 'ReceiveConversationInfos';
}
