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
    this.contactUsername,
    this.messages,
    this.isPrevious = false,
    this.currentConversation,
    // bool isPrevious,
    int? index,
  });

  List<Conversation>? conversations;
  Conversation? currentConversation;
  List<Message>? messages;
  final FormzStatus status;
  final MessageContent messageContent;
  final String? errorMessage;
  final AulareException? exception;
  bool isPrevious;
  final User? user;
  String? contactUsername;

  MessagingState copyWith(
      {FormzStatus? status,
      MessageContent? messageContent,
      Conversation? currentConversation,
      String? errorMessage,
      AulareException? exception}) {
    return MessagingState(
      status: status ?? this.status,
      messageContent: messageContent ?? this.messageContent,
      currentConversation: currentConversation ?? this.currentConversation,
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

class FetchingMessages extends MessagingState {
  @override
  String toString() => 'FetchingMessages';
}

class MessagesFetched extends MessagingState {
  MessagesFetched(this.messages, this.contactUsername, {required this.isPrevious})
      : super(messages: messages, contactUsername: contactUsername, isPrevious: isPrevious);

  final List<Message>? messages;
  final String? contactUsername;
  final isPrevious;

  //idk if the stringify makes this unnecessary
  @override
  String toString() =>
      'MessagesFetched {messages: ${messages!.length}, username: $contactUsername, '
      'isPrevious: $isPrevious}'
      '';
}

class ContactDetailsFetched extends MessagingState {
  ContactDetailsFetched(this.user, this.contactUsername)
      : super(user: user, contactUsername: contactUsername);
  final User user;
  final String? contactUsername;

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
