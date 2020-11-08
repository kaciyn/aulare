import 'package:aulare/views/conversations/components/conversation.dart';
import 'package:aulare/views/messaging/bloc/message.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessagingEvent extends Equatable {
  MessagingEvent([List props = const <dynamic>[]]) : super();
}

class FetchMessagesEvent extends MessagingEvent {
  FetchMessagesEvent(this.conversation) : super([conversation]);
  final Conversation conversation;

  @override
  List<Object> get props => [conversation];

  @override
  bool get stringify => true;
}

//i think i'm gonna make the message all one big thing instead of having like a separate text/photo/file etc message
class MessageReceivedEvent extends MessagingEvent {
  MessageReceivedEvent(this.messages) : super([messages]);
  final List<Message> messages;

  @override
  List<Object> get props => [messages];

  @override
  bool get stringify => true;
}

class SendMessageEvent extends MessagingEvent {
  // SendMessageEvent({@required this.message}) : assert(message != null);
  SendMessageEvent(this.message) : super([message]);
  final Message message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

//TODO IMPLEMENT THESE LATER
class EditMessageEvent extends MessagingEvent {
  EditMessageEvent(this.messageIndex) : super([messageIndex]);
  final int messageIndex;

  @override
  List<Object> get props => [messageIndex];

  @override
  bool get stringify => true;
}

class DeleteMessageEvent extends MessagingEvent {
  DeleteMessageEvent(this.messageIndex) : super([messageIndex]);
  final int messageIndex;

  @override
  List<Object> get props => [messageIndex];

  @override
  bool get stringify => true;
}
