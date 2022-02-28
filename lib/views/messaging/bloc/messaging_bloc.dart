import 'dart:async';

import 'package:aulare/models/user.dart';
import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
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
      : super(Initial());

  final MessagingRepository messagingRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  Map<String, StreamSubscription> messagesSubscriptionMap = {};
  StreamSubscription conversationsSubscription;

  String currentConversationId;

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    print(event);
    if (event is MessageContentAdded) {
      yield InputNotEmpty(event.messageText);
    }
    if (event is FetchConversationList) {
      yield* mapFetchConversationListEventToState(event);
    }
    if (event is ReceiveNewConversation) {
      yield ConversationListFetched(event.conversationList);
    }
    if (event is ScrollPage) {
      currentConversationId = event.currentConversation.conversationId;
      yield PageScrolled(event.index, event.currentConversation);
    }
    if (event is FetchCurrentConversationDetails) {
      add(FetchRecentMessagesAndSubscribe(event.conversation));
      yield* mapFetchConversationInfoDetailsEventToState(event);
    }
    if (event is FetchRecentMessagesAndSubscribe) {
      mapFetchMessagesEventToState(event);
    }
    if (event is FetchPreviousMessages) {
      mapFetchPreviousMessagesEventToState(event);
    }
    if (event is ReceiveMessage) {
      print(event.messages);
      yield MessagesFetched(event.messages, event.username, isPrevious: false);
    }
    if (event is SendMessage) {
      final message = Message(
          event.messageText,
          DateTime.now(),
          SharedObjects.preferences.getString(Constants.sessionName),
          SharedObjects.preferences.getString(Constants.sessionUsername));
      await messagingRepository.sendMessage(currentConversationId, message);
    }
    // if (event is PickedAttachmentEvent) {
    //   await mapPickedAttachmentEventToState(event);
    // }
  }

  Stream<MessagingState> mapFetchConversationListEventToState(
      FetchConversationList event) async* {
    try {
      await conversationsSubscription?.cancel();
      conversationsSubscription = messagingRepository.getConversations().listen(
          (conversations) => add(ReceiveNewConversation(conversations)));
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      yield Error(exception);
    }
  }

  Stream<MessagingState> mapFetchMessagesEventToState(
      FetchRecentMessagesAndSubscribe event) async* {
    try {
      yield Initial();

      final conversationId = await messagingRepository
          .getConversationIdByUsername(event.conversation.username);

      print('mapFetchMessagesEventToState');
      // print('MessSubMap: $messagesSubscriptionMap');

      var messagesSubscription = messagesSubscriptionMap[conversationId];
      await messagesSubscription?.cancel();
      messagesSubscription = messagingRepository
          .getMessages('conversationId')
          .listen((messages) =>
              add(ReceiveMessage(messages, event.conversation.username)));
      messagesSubscriptionMap[conversationId] = messagesSubscription;
    } on Exception catch (exception) {
      print(exception.toString());
      yield Error(exception);
    }
  }

  Stream<MessagingState> mapFetchPreviousMessagesEventToState(
      FetchPreviousMessages event) async* {
    try {
      final conversationId = await messagingRepository
          .getConversationIdByUsername(event.conversation.username);
      final messages = await messagingRepository.getPreviousMessages(
          conversationId, event.lastMessage);
      yield MessagesFetched(messages, event.conversation.username,
          isPrevious: true);
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      yield Error(exception);
    }
  }

  Stream<MessagingState> mapFetchConversationInfoDetailsEventToState(
      FetchCurrentConversationDetails event) async* {
    final user = await userDataRepository.getUser(event.conversation.username);
    print(user);
    yield ContactDetailsFetched(user, event.conversation.username);
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
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    super.close();
  }
}
