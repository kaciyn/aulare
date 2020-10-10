import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:honours/views/messaging/components/Message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationEvent extends Equatable {
  ConversationEvent([List props = const <dynamic>[]]) : super();
}

class FetchConversationListEvent extends ConversationEvent {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class NewConversationReceivedEvent extends ConversationEvent {
  final List<Conversation> conversationList = //TODO
      []; //ah i see this is all open conversations/rooms

  @override
  List<Object> get props => [conversationList];

  @override
  bool get stringify => true;
}

// get details of currently open conversation, don't know if i'll ever implement
class FetchConversationDetailsEvent extends ConversationEvent {
  final Conversation conversation;

  FetchConversationDetailsEvent(this.conversation) : super([conversation]);

  @override
  List<Object> get props => [conversation];

  @override
  bool get stringify => true;
}

class FetchConversationMessageListEvent extends ConversationEvent {
  final Conversation
      conversation; //this needs to actually get messages later also whyyyy is this empty and the below one has what i think should be in this one???? WHY

  FetchConversationMessageListEvent(this.conversation) : super([conversation]);

  @override
  List<Object> get props => [conversation];

  @override
  bool get stringify => true;
}

class PageUpdatedEvent extends ConversationEvent {
  final int index;

  final Conversation activeConversation;

  PageUpdatedEvent(this.index, this.activeConversation)
      : super([index, activeConversation]);

  @override
  List<Object> get props => [index, activeConversation];

  @override
  bool get stringify => true;
}
