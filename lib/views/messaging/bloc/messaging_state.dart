part of 'messaging_bloc.dart';

@immutable
abstract class MessagingState extends Equatable {
  const MessagingState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class Initial extends MessagingState {
  @override
  String toString() => 'Initial';
}

class ConversationListFetched extends MessagingState {
  ConversationListFetched(this.conversations) : super([conversations]);
  final List<Conversation>? conversations;

  @override
  String toString() => 'ConversationListFetched';
}

class MessagesFetched extends MessagingState {
  MessagesFetched(this.messages, this.username, {this.isPrevious})
      : super([messages, username, isPrevious]);

  final List<Message>? messages;
  final String? username;
  final isPrevious;

  //idk if the stringify makes this unnecessary
  @override
  String toString() =>
      'MessagesFetched {messages: ${messages!.length}, username: $username, '
      'isPrevious: $isPrevious}'
      '';
}

class ContactDetailsFetched extends MessagingState {
  ContactDetailsFetched(this.user, this.username) : super([user, username]);
  final User user;
  final String? username;

  @override
  String toString() => 'ContactDetailsFetched';
}

class InputNotEmpty extends MessagingState {
  InputNotEmpty(this.messageText) : super([messageText]);
  final String? messageText;

  @override
  String toString() => 'InputNotEmpty';
}

class PageScrolled extends MessagingState {
  PageScrolled(this.index, this.currentConversation)
      : super([index, currentConversation]);

  final int? index;
  final Conversation? currentConversation;

  @override
  String toString() => 'PageChanged';
}

class Error extends MessagingState {
  Error(this.exception) : super([exception]);
  final Exception exception;

  @override
  String toString() => 'Error';
}
