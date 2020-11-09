import 'dart:async';

import 'package:aulare/models/user.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/views/conversations/models/conversation.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  // final Messages _messaging;

  MessagingBloc(
      {this.messagingRepository,
      this.userDataRepository,
      this.storageRepository})
      : super(InitialMessagingState());

  final MessagingRepository messagingRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  StreamSubscription messagesSubscription;
  StreamSubscription conversationsSubscription;

  String activeConversationId;

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    print(event);
    if (event is FetchConversationList) {
      yield* mapFetchConversationListEventToState(event);
    }
    if (event is ReceiveNewConversation) {
      yield FetchedConversationList(event.conversationList);
    }
    if (event is UpdatePage) {
      activeConversationId = event.activeConversation.conversationId;
    }
    if (event is FetchCurrentConversationDetails) {
      add(FetchMessages(event.conversation));
      yield* mapFetchConversationDetailsEventToState(event);
    }
    if (event is FetchMessages) {
      mapFetchMessagesEventToState(event);
    }
    if (event is ReceiveMessage) {
      print(event.messages);
      yield MessagesFetched(event.messages);
    }
    if (event is SendMessage) {
      final message =
          Message(event.message.text, DateTime.now(), 'sender', 'senderusn');
      await messagingRepository.sendMessage('conversationId', message);
    }
    // if (event is PickedAttachmentEvent) {
    //   await mapPickedAttachmentEventToState(event);
    // }
  }

  Stream<MessagingState> mapFetchConversationListEventToState(
      FetchConversationList event) async* {
    try {
      await conversationsSubscription?.cancel();
      conversationsSubscription = messagingRepository
          .getConversations()
          .listen((chats) => add(ReceiveNewConversation(chats)));
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      yield Error(exception);
    }
  }

  Stream<MessagingState> mapFetchMessagesEventToState(
      FetchMessages event) async* {
    try {
      yield InitialMessagingState();
      await messagesSubscription?.cancel();
      messagesSubscription = messagingRepository
          .getMessages('conversationId')
          .listen((messages) => add(ReceiveMessage(messages)));
    } on Exception catch (exception) {
      print(exception.toString());
      yield Error(exception);
    }
  }

  Stream<MessagingState> mapFetchConversationDetailsEventToState(
      FetchCurrentConversationDetails event) async* {
    final user =
        await userDataRepository.getUser(event.conversation.user.username);
    print(user);
    yield ContactDetailsFetched(user);
  }

  //
  // Future mapPickedAttachmentEventToState(PickedAttachmentEvent event) async {
  //   String url = await storageRepository.uploadFile(
  //       event.file, Paths.imageAttachmentsPath);
  //   String username = SharedObjects.prefs.getString(Constants.sessionUsername);
  //   String name = SharedObjects.prefs.getString(Constants.sessionName);
  //   Message message = VideoMessage(
  //       url, DateTime.now().millisecondsSinceEpoch, name, username);
  //   await conversationRepository.sendMessage(event.chatId, message);
  // }

  @override
  Future<void> close() {
    messagesSubscription.cancel();
    super.close();
  }
}
