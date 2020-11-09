part of 'conversation_bloc.dart';

@immutable
abstract class ConversationEvent extends Equatable {
  ConversationEvent([List props = const <dynamic>[]]);
  @override
  List<Object> get props => <dynamic>[];
}

class FetchConversationListEvent extends ConversationEvent {
  @override
  String toString() => 'InitialMessagingState';
}

class NewConversationReceivedEvent extends ConversationEvent {
  final List<Conversation> conversationList = //TODO
      []; //ah i see this is all open conversations/rooms

  @override
  String toString() => 'InitialMessagingState';
}

// get details of currently open conversation, don't know if i'll ever implement
class FetchConversationDetailsEvent extends ConversationEvent {
  final Conversation conversation;

  FetchConversationDetailsEvent(this.conversation) : super([conversation]);

  @override
  String toString() => 'InitialMessagingState';
}

class FetchConversationMessageListEvent extends ConversationEvent {
  final Conversation
      conversation; //this needs to actually get messages later also whyyyy is this empty and the below one has what i think should be in this one???? WHY

  FetchConversationMessageListEvent(this.conversation) : super([conversation]);

  @override
  String toString() => 'InitialMessagingState';
}

class PageUpdatedEvent extends ConversationEvent {
  final int index;

  final Conversation activeConversation;

  PageUpdatedEvent(this.index, this.activeConversation)
      : super([index, activeConversation]);

  @override
  String toString() => 'InitialMessagingState';
}
