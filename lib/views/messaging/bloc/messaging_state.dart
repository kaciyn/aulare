part of 'messaging_bloc.dart';

@immutable
abstract class MessagingState extends Equatable {
  const MessagingState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];
}

class InitialMessagingState extends MessagingState {
  @override
  String toString() => 'InitialMessagingState';
}

class MessagesFetched extends MessagingState {
  MessagesFetched(this.messageList) : super([messageList]);

  final List<Message> messageList;

  @override
  String toString() => 'FetchedMessagesState';
}

class Error extends MessagingState {
  Error(this.exception) : super([exception]);
  final Exception exception;

  @override
  String toString() => 'ErrorState';
}
