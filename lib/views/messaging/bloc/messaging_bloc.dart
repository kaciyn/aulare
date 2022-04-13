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
    on<MessageContentChanged>((event, emit) {
      final messageContent = MessageContent.dirty(event.messageContent);
      print('Message content: ${messageContent.value}');
      emit(state.copyWith(
        messageContent: messageContent,
        status: Formz.validate([messageContent]),
      ));
    });

    on<FetchConversationList>(
      (event, emit) async {
        try {
          // await conversationsSubscription.cancel();

          await emit.forEach(messagingRepository.getConversations(),
              onData: (List<Conversation> conversationList) =>
                  ConversationListFetched(conversationList));

          // conversationsSubscription = messagingRepository
          //     .getConversations()
          //     .listen((conversationList) =>
          //         add(ReceiveNewConversation(conversationList)));
        } on AulareException catch (exception) {
          print(exception.errorMessage());
          emit(Error(exception));
        }
      },
      // Allow only one of these events to ever be active at once, canceling
      // any active `emit.forEach` above.
      // transformer: restartable(),
    );

    // on<ReceiveNewConversation>((event, emit) {
    //   emit(ConversationListFetched(event.conversationList));
    // });

    //////////////MESSAGING PAGE
    // on<FetchCurrentConversationDetails>((event, emit) async {
    //   add(FetchMessages(event.conversation));
    //   final user = await userDataRepository.getUser(
    //       username: event.conversation.contact.username);
    //   // if (kDebugMode) {
    //   print(user);
    //   // }
    //   emit(ContactDetailsFetched(user, event.conversation.contact.username)
    //       .copyWith(currentConversation: event.conversation,));
    // });

    on<FetchMessages>((event, emit) async {
      try {
        emit(FetchingMessages());

        final conversationId = await messagingRepository
            .getConversationIdByUsername(event.conversation.contact.username);

        // print('mapFetchMessagesEventToState');
        // print('MessSubMap: $messagesSubscriptionMap');

        // var messagesSubscription = messagesSubscriptionMap[conversationId];

        await emit.forEach(messagingRepository.getMessages(conversationId),
            onData: (List<Message> messages) => MessagesFetched().copyWith(
                messages: messages,
                contactUsername: event.conversation.contact.username,
                isPrevious: false));

        // await messagesSubscription?.cancel();
        // messagesSubscription = messagingRepository
        //     .getMessages('conversationId')
        //     .listen((messages) => add(ReceiveMessage(
        //         messages, event.conversation!.contact.username)));
        // messagesSubscriptionMap[conversationId] = messagesSubscription;
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

        emit(MessagesFetched().copyWith(
            messages: messages,
            contactUsername: event.conversation.contact.username,
            isPrevious: true));
      } on AulareException catch (exception) {
        print(exception.errorMessage());
        emit(Error(exception));
      }
    });

    // on<ReceiveMessage>((event, emit) {
    //   print(event.messages);
    //   emit(MessagesFetched().copyWith(
    //       messages: event.messages,
    //       contactUsername: event.contactUsername,
    //       isPrevious: false));
    // });

    on<SendMessage>((event, emit) async {
      if (state.status.isValidated) {
        var conversationId = event.conversationId;
        var messageContent = event.textEditingController.text;

        emit(state.copyWith(
          status: FormzStatus.submissionInProgress,
        ));

        final message = Message.idLess(messageContent, DateTime.now(),
            SharedObjects.preferences.getString(Constants.sessionUsername));

        try {
          await messagingRepository.sendMessage(conversationId, message);

          emit(state.copyWith(status: FormzStatus.submissionSuccess));
          event.textEditingController.clear();
        } catch (_) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      }
    });

    on<PageChanged>((event, emit) {
      currentConversationId = event.currentConversation.conversationId;
      emit(PageScrolled(event.index, event.currentConversation));
    });
  }

  @override
  Future<void> close() async {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());

    return super.close();
  }

//     Future<void> _onSendMessage(event, emit) async {
//   final message = Message(
//       event.messageText,
//       DateTime.now(),
//       // SharedObjects.preferences.getString(Constants.sessionName),
//       SharedObjects.preferences.getString(Constants.sessionUsername));
//   await messagingRepository!.sendMessage(currentConversationId, message);
// });

// void _onReceiveNewConversation(event, emit) {
// emit(ConversationListFetched(event.conversationList));
// });

// UNSURE IF THESE WERE EVER MEANT TO BE IMPLEMENTED OR IF THEY'RE A LEFTOVER?
// on<PickedAttachment>(_onPickedAttachment);
// on<FetchMessages>(_onFetchMessages);
// on<FetchConversationInfoDetails>(_onFetchConversationInfoDetails);

//
// void _onMessageContentAdded(event, emit) {
//   emit(InputNotEmpty(event.messageText));
// }
//
// Stream<void> _onFetchConversationList(event, emit) async* {
//   try {
//     await conversationsSubscription.cancel();
//     conversationsSubscription = messagingRepository!
//         .getConversations()
//         .listen(
//             (conversations) => add(ReceiveNewConversation(conversations)));
//   } on AulareException catch (exception) {
//     print(exception.errorMessage());
//     emit(Error(exception));
//   }
// }
//
// void _onReceiveNewConversation(event, emit) {
//   emit(ConversationListFetched(event.conversationList));
// }
//
// void _onScrollPage(event, emit) {
//   currentConversationId = event.currentConversation.conversationId;
//   emit(PageScrolled(event.index, event.currentConversation));
// }
//
// Stream<MessagingState> _onFetchCurrentConversationDetails(
//     event, emit) async* {
//   add(FetchRecentMessagesAndSubscribe(event.conversation));
//   final user = await userDataRepository!
//       .getUser(username: event.conversation.username);
//   // if (kDebugMode) {
//   print(user);
//   // }
//   emit(ContactDetailsFetched(user, event.conversation.username));
// }
//
// Stream<MessagingState> _onFetchRecentMessagesAndSubscribe(
//     event, emit) async* {
//   try {
//     emit(Initial());
//
//     final conversationId = await messagingRepository!
//         .getConversationIdByUsername(event.conversation.username);
//
//     print('mapFetchMessagesEventToState');
//     // print('MessSubMap: $messagesSubscriptionMap');
//
//     var messagesSubscription = messagesSubscriptionMap[conversationId];
//     await messagesSubscription?.cancel();
//     messagesSubscription = messagingRepository!
//         .getMessages('conversationId')
//         .listen((messages) =>
//             add(ReceiveMessage(messages, event.conversation.username)));
//     messagesSubscriptionMap[conversationId] = messagesSubscription;
//   } on Exception catch (exception) {
//     print(exception.toString());
//     emit(Error(exception));
//   }
// }
//
// Stream<MessagingState> _onFetchPreviousMessages(event, emit) async* {
//   try {
//     final conversationId = await messagingRepository!
//         .getConversationIdByUsername(event.conversation.username);
//     final messages = await messagingRepository!
//         .getPreviousMessages(conversationId, event.lastMessage);
//     emit(MessagesFetched(messages, event.conversation.username,
//         isPrevious: true));
//   } on AulareException catch (exception) {
//     print(exception.errorMessage());
//     emit(Error(exception));
//   }
// }
//
// void _onReceiveMessage(event, emit) {
//   print(event.messages);
//   emit(MessagesFetched(event.messages, event.username, isPrevious: false));
// }
//
// Future<void> _onSendMessage(event, emit) async {
//   final message = Message(
//       event.messageText,
//       DateTime.now(),
//       // SharedObjects.preferences.getString(Constants.sessionName),
//       SharedObjects.preferences.getString(Constants.sessionUsername));
//   await messagingRepository!.sendMessage(currentConversationId, message);
// }

// Future<void> _onPickedAttachment(event, emit) async {
//   // NOT IMPLEMENTED (YET) (OR EVER)
//
//   String url = await storageRepository.uploadFile(
//       event.file, Paths.imageAttachmentsPath);
//   String username = SharedObjects.prefs.getString(Constants.sessionUsername);
//   String name = SharedObjects.prefs.getString(Constants.sessionName);
//   Message message = VideoMessage(
//       url, DateTime
//       .now()
//       .millisecondsSinceEpoch, name, username);
//   await conversationRepository.sendMessage(event.chatId, message);
// }
}
