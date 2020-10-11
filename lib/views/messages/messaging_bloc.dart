import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:honours/views/messaging/conversation_state.dart';
import 'package:honours/views/messaging/ConversationEvent.dart';


class MessagingBloc extends Bloc<ConversationState, ConversationEvent> {

  final Messaging _messaging;

  MessagingBloc(this._messaging) : assert(_messaging != null);

  @override
  ConversationState get initialState => MessagesBefore();

  @override
  Stream<ConversationState> mapEventToState(ConversationState event) async* {
    if (event is MessageSent) {

    final
    message
    .
    text
    = event.text;
    final message.formattedTimestamp=datetime.now()formatted;
    final message.attachments=event.attachments (List<files>);
    _messages.add(message);
    yield messages: messages);
    } else if (event is EditEvent) {
    _musicPlayer.pause();
    yield MusicPlayerPaused();
    } else if (event is DeleteEvent) {
    _musicPlayer.stop();
    yield MusicPlayerIdle();
    }
  }
}}
