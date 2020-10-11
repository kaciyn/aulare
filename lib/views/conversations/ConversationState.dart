import 'package:equatable/equatable.dart';
import 'package:honours/views/messaging/components/message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationState extends Equatable {
  const ConversationState([List props = const <dynamic>[]]) : super();
}

class InitialConversationState extends ConversationState {
  @override
  List<Object> get props => [];
}

class MessagesFetchedState extends ConversationState {
  final List<Message> messageList;

  MessagesFetchedState(this.messageList) : super([messageList]);

  @override
  List<Object> get props => [messageList];

  @override
  bool get stringify => true;
}

class ErrorState extends ConversationState {
  final Exception exception;

  ErrorState(this.exception) : super([exception]);

  @override
  List<Object> get props => [exception];

  @override
  bool get stringify => true;
}
