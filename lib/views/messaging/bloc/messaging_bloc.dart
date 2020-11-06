import 'dart:async';
import 'dart:ui';

import 'package:aulare/views/messaging/bloc/messaging_event.dart';
import 'package:aulare/views/messaging/bloc/messaging_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MessagingBloc extends Bloc<MessagingState, MessagingEvent> {

  // final Messages _messaging;

  MessagingBloc(
      {this.chatRepository, this.userDataRepository, this.storageRepository})
      : super(InitialMessagingState());

  final ChatRepository chatRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;
  StreamSubscription subscription;

  @override
  Stream<MessagingState> mapEventToState(MessagingEvent event,) async* {
    print(event);
    if (event is FetchMessagesEvent) {
      mapFetchMessagesEventToState(event);
    }
    if (event is ReceivedMessagesEvent) {
      print(event.messages);
      yield FetchedMessagesState(event.messages);
    }
    if (event is SendTextMessageEvent) {
      await chatRepository.sendMessage(event.chatId, event.message);
    }
    if (event is PickedAttachmentEvent) {
      await mapPickedAttachmentEventToState(event);
    }
  }


}}
