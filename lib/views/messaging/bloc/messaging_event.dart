part of 'messaging_bloc.dart';

@immutable
abstract class MessagingEvent extends Equatable {
  const MessagingEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];
}

class FetchMessagesEvent extends MessagingEvent {
  FetchMessagesEvent(this.room) : super([room]);
  final Room room;

  @override
  String toString() => 'FetchMessagesEvent';
}

//i think i'm gonna make the message all one big thing instead of having like a separate text/photo/file etc message
class MessageReceivedEvent extends MessagingEvent {
  MessageReceivedEvent(this.messages) : super([messages]);
  final List<Message> messages;
  @override
  String toString() => 'MessageReceivedEvent';
}

class SendMessageEvent extends MessagingEvent {
  // SendMessageEvent({@required this.message}) : assert(message != null);
  SendMessageEvent(this.message) : super([message]);
  final Message message;

  @override
  String toString() => 'SendMessageEvent';
}

//TODO IMPLEMENT THESE LATER
class EditMessageEvent extends MessagingEvent {
  EditMessageEvent(this.messageIndex) : super([messageIndex]);
  final int messageIndex;

  @override
  String toString() => 'EditMessageEvent';
}

class DeleteMessageEvent extends MessagingEvent {
  DeleteMessageEvent(this.messageIndex) : super([messageIndex]);
  final int messageIndex;

  @override
  String toString() => 'DeleteMessageEvent';
}
