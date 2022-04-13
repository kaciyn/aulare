part of 'messaging_bloc.dart';

@immutable
class MessagingState extends Equatable {
  MessagingState({
    this.conversations,
    this.index,
    this.status = FormzStatus.pure,
    // this.messageContent = const MessageContent.pure(),
    // this.conversations,
    // this.currentConversation,
    // this.errorMessage,
    this.exception,
    // this.user,
    // this.contactUsername,
    this.messages,
    this.isPrevious = false,
    // int? index,
  });

  final FormzStatus status;

  // final MessageContent messageContent;
  //
  List<Conversation>? conversations;

  // Conversation? currentConversation;
  //
  List<Message>? messages;
  //
  bool isPrevious;
  // final User? user;
  // String? contactUsername;
  //
  // final String? errorMessage;
  final AulareException? exception;

  int? index;

  MessagingState copyWith({
    FormzStatus? status,
    //     // MessageContent? messageContent,
    //     // List<Conversation>? conversations,
    //     // Conversation? currentConversation,
    //     // List<Message>? messages,
    //     // bool? isPrevious,
    //     // final User? user,
    //     // String? contactUsername,
    //     // String? errorMessage,
    //     // AulareException? exception
  }) {
    return MessagingState(
      status: status ?? this.status,
      //     messageContent: messageContent ?? this.messageContent,
      //     conversations: conversations ?? this.conversations,
      //     currentConversation: currentConversation ?? this.currentConversation,
      //     messages: messages ?? this.messages,
      //     isPrevious: isPrevious ?? this.isPrevious,
      //     user: user ?? this.user,
      //     contactUsername: contactUsername ?? this.contactUsername,
      //     errorMessage: errorMessage ?? this.errorMessage,
      //     exception: exception ?? this.exception,
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
  // FetchingMessages({
  //   this.status = FormzStatus.pure,
  //   this.messageContent = const MessageContent.pure(),
  //   this.conversations,
  //   this.currentConversation,
  //   this.errorMessage,
  //   this.exception,
  //   this.user,
  //   this.contactUsername,
  //   this.messages,
  //   this.isPrevious = false,
  //   int? index,
  // });
  //
  // final FormzStatus status;
  // final MessageContent messageContent;
  //
  // List<Conversation>? conversations;
  // Conversation? currentConversation;
  //
  // List<Message>? messages;
  //
  // bool isPrevious;
  // final User? user;
  // String? contactUsername;
  //
  // final String? errorMessage;
  // final AulareException? exception;
  //
  // FetchingMessages copyWith(
  //     {FormzStatus? status,
  //     MessageContent? messageContent,
  //     List<Conversation>? conversations,
  //     Conversation? currentConversation,
  //     List<Message>? messages,
  //     bool? isPrevious,
  //     final User? user,
  //     String? contactUsername,
  //     String? errorMessage,
  //     AulareException? exception}) {
  //   return FetchingMessages(
  //     status: status ?? this.status,
  //     messageContent: messageContent ?? this.messageContent,
  //     conversations: conversations ?? this.conversations,
  //     currentConversation: currentConversation ?? this.currentConversation,
  //     messages: messages ?? this.messages,
  //     isPrevious: isPrevious ?? this.isPrevious,
  //     user: user ?? this.user,
  //     contactUsername: contactUsername ?? this.contactUsername,
  //     errorMessage: errorMessage ?? this.errorMessage,
  //     exception: exception ?? this.exception,
  //   );
  // }

  @override
  String toString() => 'FetchingMessages';
}

class MessagesFetched extends MessagingState {
  MessagesFetched({
    this.messages,
    this.isPrevious = false,
  });

  // final FormzStatus status;
  // final MessageContent messageContent;
  //
  // List<Conversation>? conversations;
  // Conversation? currentConversation;

  List<Message>? messages;

  bool isPrevious;
  // final User? user;
  // String? contactUsername;
  //
  // final String? errorMessage;
  // final AulareException? exception;

  @override
  MessagesFetched copyWith({
    FormzStatus? status,
    // MessageContent? messageContent,
    // List<Conversation>? conversations,
    // Conversation? currentConversation,
    List<Message>? messages,
    bool? isPrevious,
    // final User? user,
    // String? contactUsername,
    // String? errorMessage,
    // AulareException? exception
  }) {
    return MessagesFetched(
      // status: status ?? this.status,
      // messageContent: messageContent ?? this.messageContent,
      // conversations: conversations ?? this.conversations,
      // currentConversation: currentConversation ?? this.currentConversation,
      messages: messages ?? this.messages,
      isPrevious: isPrevious ?? this.isPrevious,
      // user: user ?? this.user,
      // contactUsername: contactUsername ?? this.contactUsername,
      // errorMessage: errorMessage ?? this.errorMessage,
      // exception: exception ?? this.exception,
    );
  }
}

class InputNotEmpty extends MessagingState {
  // InputNotEmpty(this.messageText) : super(messageContent: messageContent);
  // final String? messageText;

  @override
  String toString() => 'InputNotEmpty';
}

class PageScrolled extends MessagingState {
  PageScrolled(
    // {
    // this.status = FormzStatus.pure,
    // this.messageContent = const MessageContent.pure(),
    // this.conversations,
    // this.currentConversation,
    // this.errorMessage,
    // this.exception,
    // this.user,
    // this.contactUsername,
    // this.messages,
    // this.isPrevious = false,
    this.index,
    // }
  ) : super(index: index);

  // final FormzStatus status;
  // final MessageContent messageContent;
  //
  // List<Conversation>? conversations;
  // Conversation? currentConversation;
  //
  // List<Message>? messages;
  //
  // bool isPrevious;
  // final User? user;
  // String? contactUsername;
  //
  // final String? errorMessage;
  // final AulareException? exception;

  final int? index;

  @override
  String toString() => 'PageChanged';
}

class Error extends MessagingState {
  Error(this.exception) : super(exception: exception);
  final AulareException exception;

  @override
  String toString() => 'Error';
}
