import 'package:aulare/views/messaging/components/message.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessagingEvent extends Equatable {
  MessagingEvent([List props = const <dynamic>[]]) : super();
}

//i think i'm gonna make the message all one big thing instead of having like a separate text/photo/file etc message
class NewMessageReceivedEvent extends MessagingEvent {
  NewMessageReceivedEvent(this.messageList) : super([messageList]);
  final List<Message> messageList;

  @override
  List<Object> get props => [messageList];

  @override
  bool get stringify => true;
}

class MessageSentEvent extends MessagingEvent {
  MessageSentEvent({@required this.message}) : assert(message != null);
  final Message message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

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
