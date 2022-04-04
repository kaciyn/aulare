part of 'messaging_bloc.dart';

@immutable
class MessagingState extends Equatable {
  MessagingState({
    this.status = FormzStatus.pure,
    this.messageContent = const MessageContent.pure(),
    this.conversations,
    this.errorMessage,
    this.exception,
    this.user,
    this.username,
    this.messages,
    this.isPrevious = false,
    // bool isPrevious,
    Conversation? currentConversation,
    int? index,
  });

  List<Conversation>? conversations;
  List<Message>? messages;
  final FormzStatus status;
  final MessageContent messageContent;
  final String? errorMessage;
  final AulareException? exception;
  bool isPrevious;
  final User? user;
  String? username;

  MessagingState copyWith(
      {FormzStatus? status,
      MessageContent? messageContent,
      String? errorMessage,
      AulareException? exception}) {
    return MessagingState(
      status: status ?? this.status,
      messageContent: messageContent ?? this.messageContent,
      errorMessage: errorMessage ?? this.errorMessage,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => <dynamic>[];

  @override
  String toString() => 'MessagingState';
}

class Initial extends MessagingState {
  Initial() : super();

  @override
  String toString() => 'Initial';
}

class ConversationListFetched extends MessagingState {
  ConversationListFetched(this.conversations)
      : super(conversations: conversations);
  final List<Conversation>? conversations;

  @override
  String toString() => 'ConversationListFetched';
}

class MessagesFetched extends MessagingState {
  MessagesFetched(this.messages, this.username, {required this.isPrevious})
      : super(messages: messages, username: username, isPrevious: isPrevious);

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
  ContactDetailsFetched(this.user, this.username)
      : super(user: user, username: username);
  final User user;
  final String? username;

  @override
  String toString() => 'ContactDetailsFetched';
}

class InputNotEmpty extends MessagingState {
  // InputNotEmpty(this.messageText) : super(messageContent: messageContent);
  // final String? messageText;

  @override
  String toString() => 'InputNotEmpty';
}

class PageScrolled extends MessagingState {
  PageScrolled(this.index, this.currentConversation)
      : super(index: index, currentConversation: currentConversation);

  final int? index;
  final Conversation? currentConversation;

  @override
  String toString() => 'PageChanged';
}

class Error extends MessagingState {
  Error(this.exception) : super(exception: exception);
  final AulareException exception;

  @override
  String toString() => 'Error';
}
