import 'package:equatable/equatable.dart';
import 'package:honours/views/messaging/components/message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessageEvent extends Equatable {
  MessageEvent([List props = const <dynamic>[]]) : super();
}

//i think i'm gonna make the message all one big thing instead of having like a separate text/photo/file etc message
class NewMessageReceivedEvent extends MessageEvent {
  final List<Message> messageList;

  NewMessageReceivedEvent(this.messageList) : super([messageList]);

  @override
  List<Object> get props => [messageList];

  @override
  bool get stringify => true;
}

class MessageSentEvent extends MessageEvent {
  final Message message;

  MessageSentEvent({@required this.message}) : assert(message != null);

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class EditMessageEvent extends MessageEvent {
  final int messageIndex;

  EditMessageEvent(this.messageIndex) : super([messageIndex]);

  @override
  List<Object> get props => [messageIndex];

  @override
  bool get stringify => true;
}

class DeleteMessageEvent extends MessageEvent {
  final int messageIndex;

  DeleteMessageEvent(this.messageIndex) : super([messageIndex]);

  @override
  List<Object> get props => [messageIndex];

  @override
  bool get stringify => true;
}
