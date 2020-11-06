import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../components/message.dart';

@immutable
abstract class MessagingState extends Equatable {
  const MessagingState([List props = const <dynamic>[]]) : super();
}

class InitialMessagingState extends MessagingState {
  @override
  List<Object> get props => [];
}

class MessagesFetchedState extends MessagingState {
  MessagesFetchedState(this.messageList) : super([messageList]);

  final List<Message> messageList;

  @override
  List<Object> get props => [messageList];

  @override
  bool get stringify => true;
}

class ErrorState extends MessagingState {
  ErrorState(this.exception) : super([exception]);
  final Exception exception;

  @override
  List<Object> get props => [exception];

  @override
  bool get stringify => true;
}
