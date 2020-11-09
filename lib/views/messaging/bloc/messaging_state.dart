part of 'messaging_bloc.dart';

@immutable
abstract class MessagingState extends Equatable {
  const MessagingState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class InitialMessagingState extends MessagingState {
  @override
  String toString() => 'InitialMessagingState';
}

class ConversationListFetched extends MessagingState {
  ConversationListFetched(this.conversations) : super([conversations]);
  final List<Conversation> conversations;

  @override
  String toString() => 'ConversationListFetched';
}

class MessagesFetched extends MessagingState {
  MessagesFetched(this.messages, this.username, {this.isPrevious})
      : super([messages, username, isPrevious]);

  final List<Message> messages;
  final String username;
  final isPrevious;

  //idk if the stringify makes this unnecessary
  @override
  String toString() =>
      'MessagesFetched {messages: ${messages.length}, username: $username, isPrevious: $isPrevious}';
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
