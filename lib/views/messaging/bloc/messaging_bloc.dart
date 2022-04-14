import 'dart:async';

import 'package:aulare/models/user.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../../models/message.dart';
import '../models/conversation.dart';

part 'messaging_event.dart';

part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  // final Messages _messaging;

  late MessagingRepository messagingRepository;
  late UserDataRepository userDataRepository;

  // late StorageRepository storageRepository;
  final Map<String, StreamSubscription> messagesSubscriptionMap = {};

  String? currentConversationId;

  MessagingBloc({
    required MessagingRepository messagingRepository,
    required UserDataRepository userDataRepository,
    // required StorageRepository storageRepository
  }) : super(Initial()) {
    // on<MessageContentChanged>((event, emit) {
    //   final messageContent = MessageContent.dirty(event.messageContent);
    //   print('Message content: ${messageContent.value}');
    //   emit(state.copyWith(
    //     messageContent: messageContent,
    //     status: Formz.validate([messageContent]),
    //   ));
    // });

    on<FetchConversationList>(
      (event, emit) async {
        try {
          // await conversationsSubscription.cancel();

          await emit.forEach(
            messagingRepository.getConversations(),
            onData: (List<Conversation> conversationList) =>
                ConversationListFetched(conversationList),
          );
        } on AulareException catch (exception) {
          print(exception.errorMessage());
          emit(Error(exception));
        }
      },
      // Allow only one of these events to ever be active at once, canceling
      // any active `emit.forEach` above.
      // transformer: restartable(),
    );

    on<FetchMessages>((event, emit) async {
      try {
        emit(FetchingMessages()
            .copyWith(currentConversation: event.conversation));

        await emit.forEach(
            messagingRepository.getMessages(event.conversation.conversationId),
            onData: (List<Message> messages) => MessagesFetched().copyWith(
                currentConversation: event.conversation,
                messages: messages,
                isPrevious: false));
      } on AulareException catch (exception) {
        print(exception.toString());
        emit(Error(exception));
      }
    });

    on<FetchOlderMessages>((event, emit) async {
      try {
        final conversationId = await messagingRepository
            .getConversationIdByUsername(event.conversation.contact.username);

        final messages = await messagingRepository.getOlderMessages(
            conversationId, event.lastMessage);

        emit(MessagesFetched().copyWith(messages: messages, isPrevious: true));
      } on AulareException catch (exception) {
        print(exception.errorMessage());
        emit(Error(exception));
      }
    });

    on<SendMessage>((event, emit) async {
      Conversation conversation = event.conversation;
      final messageContent =
          MessageContent.dirty(event.textEditingController.text);
      if (Formz.validate([messageContent]) == FormzStatus.valid) {
        emit(state.copyWith(
          status: FormzStatus.submissionInProgress,
        ));

        final message = Message.idLess(messageContent.value, DateTime.now(),
            SharedObjects.preferences.getString(Constants.sessionUsername));

        try {
          await messagingRepository.sendMessage(
              conversation.conversationId, message);

          emit(state.copyWith(status: FormzStatus.submissionSuccess));
          event.textEditingController.clear();
        } catch (_) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
        add(FetchMessages(event.conversation));
        add(FetchConversationList());
      }
    });

    on<PageChanged>((event, emit) {
      currentConversationId = event.currentConversation.conversationId;
      emit(PageScrolled(event.index));
      //   .copyWith(
      // index: event.index,
      // currentConversation: event.currentConversation,
      // messageContent: state.messageContent,
      // status: state.status,
      // messages: state.messages,
      // ));
    });
  }

  @override
  Future<void> close() async {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());

    return super.close();
  }
}
