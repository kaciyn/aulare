part of 'messaging_bloc.dart';

@immutable
abstract class MessagingEvent extends Equatable {
  const MessagingEvent([List props = const <dynamic>[]]);

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

//triggered to fetch list of chats
class FetchConversationList extends MessagingEvent {
  @override
  String toString() => 'FetchConversationList';
}

//triggered when stream containing list of chats has new data
class ReceiveNewConversation extends MessagingEvent {
  const ReceiveNewConversation(this.conversationList);

  final List<Conversation> conversationList;

  @override
  String toString() => 'ReceiveNewConversation';
}

//triggered to get details of currently open conversation
class FetchCurrentConversationDetails extends MessagingEvent {
  FetchCurrentConversationDetails(this.conversation) : super([conversation]);
  final Conversation conversation;

  @override
  String toString() => 'FetchCurrentConversationDetails';
}

//fetches most recent x messages and listens for new ones
class FetchRecentMessagesAndSubscribe extends MessagingEvent {
  FetchRecentMessagesAndSubscribe(this.conversation) : super([conversation]);
  final Conversation? conversation;

  @override
  String toString() => 'FetchMessages';
}

//fetch older messages (for when you scroll back)
class FetchPreviousMessages extends MessagingEvent {
  FetchPreviousMessages(this.conversation, this.lastMessage)
      : super([conversation, lastMessage]);
  final Conversation conversation;
  final Message lastMessage;

  @override
  String toString() => 'FetchPreviousMessagesEvent';
}

//i think i'm gonna make the message all one big thing instead of having like a separate text/photo/file etc message
class ReceiveMessage extends MessagingEvent {
  ReceiveMessage(this.messages, this.username) : super([messages, username]);
  final List<Message> messages;
  final String? username;

  @override
  String toString() => 'ReceiveMessage';
}

class SendMessage extends MessagingEvent {
  // SendMessageEvent({@required this.message}) : assert(message != null);
  SendMessage(this.messageText) : super([messageText]);
  final String messageText;

  @override
  String toString() => 'SendMessage';
}

class MessageContentChanged extends MessagingEvent {
  const MessageContentChanged(this.messageContent);

  final String messageContent;

  @override
  List<Object> get props => [messageContent];

  @override
  String toString() => 'MessageContentChanged';
}

//TODO IMPLEMENT THESE LATER
//would just need to get the message id and then merge into the db
class EditMessage extends MessagingEvent {
  EditMessage(this.messageIndex) : super([messageIndex]);
  final int messageIndex;

  @override
  String toString() => 'EditMessage';
}

class DeleteMessage extends MessagingEvent {
  DeleteMessage(this.messageIndex) : super([messageIndex]);
  final int messageIndex;

  @override
  String toString() => 'DeleteMessage';
}

//triggered on page change
class ScrollPage extends MessagingEvent {
  ScrollPage(this.index, this.currentConversation)
      : super([index, currentConversation]);

  final int index;
  final Conversation currentConversation;

  @override
  String toString() => 'ChangePage';
}
