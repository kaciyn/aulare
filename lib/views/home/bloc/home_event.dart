part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent([List props = const <dynamic>[]]);

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
  final List<ConversationInfo> conversationInfos;

  const ReceiveConversationInfos(this.conversationInfos);

  @override
  String toString() => 'ReceiveConversationInfos';
}
