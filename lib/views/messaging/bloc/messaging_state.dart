part of 'messaging_bloc.dart';

@immutable
abstract class MessagingState extends Equatable {
  const MessagingState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];
}

class InitialMessagingState extends MessagingState {
  @override
  String toString() => 'InitialMessagingState';
}

class FetchedConversationList extends MessagingState {
  FetchedConversationList(this.conversationList) : super([conversationList]);
  final List<Conversation> conversationList;

  @override
  String toString() => 'FetchedChatListState';
}

class MessagesFetched extends MessagingState {
  MessagesFetched(this.messageList) : super([messageList]);

  final List<Message> messageList;

  @override
  String toString() => 'MessagesFetched';
}

class ContactDetailsFetched extends MessagingState {
  ContactDetailsFetched(this.user) : super([user]);
  final User user;

  @override
  String toString() => 'ContactDetailsFetched';
}

class PageUpdated extends MessagingState {
  PageUpdated(this.index, this.activeConversation)
      : super([index, activeConversation]);

  final int index;
  final Conversation activeConversation;

  @override
  String toString() => 'PageChanged';
}

class Error extends MessagingState {
  Error(this.exception) : super([exception]);
  final Exception exception;

  @override
  String toString() => 'Error';
}
