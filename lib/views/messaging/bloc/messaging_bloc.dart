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
      : super(Initial()) {
    on<MessageContentAdded>(_onMessageContentAdded);
    on<FetchConversationList>(_onFetchConversationList);
    on<ReceiveNewConversation>(_onReceiveNewConversation);
    on<ScrollPage>(_onScrollPage);
    on<FetchCurrentConversationDetails>(_onFetchCurrentConversationDetails);
    on<FetchRecentMessagesAndSubscribe>(_onFetchRecentMessagesAndSubscribe);
    on<FetchPreviousMessages>(_onFetchPreviousMessages);
    on<ReceiveMessage>(_onReceiveMessage);
    on<SendMessage>(_onSendMessage);
    on<FetchConversationList>(_onFetchConversationList);

    //TODO UNSURE IF THESE WERE EVER MEANT TO BE IMPLEMENTED OR IF THEY'RE A LEFTOVER?
    // on<PickedAttachment>(_onPickedAttachment);
    // on<FetchMessages>(_onFetchMessages);
    // on<FetchConversationInfoDetails>(_onFetchConversationInfoDetails);
  }

  final MessagingRepository messagingRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  Map<String, StreamSubscription> messagesSubscriptionMap = {};
  StreamSubscription conversationsSubscription;

  String currentConversationId;

  void _onMessageContentAdded(event, emit) {
    emit(InputNotEmpty(event.messageText));
  }

  Stream<void> _onFetchConversationList(event, emit) async* {
    try {
      await conversationsSubscription?.cancel();
      conversationsSubscription = messagingRepository.getConversations().listen(
          (conversations) => add(ReceiveNewConversation(conversations)));
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      emit(Error(exception));
    }
  }

  void _onReceiveNewConversation(event, emit) {
    emit(ConversationListFetched(event.conversationList));
  }

  void _onScrollPage(event, emit) {
    currentConversationId = event.currentConversation.conversationId;
    emit(PageScrolled(event.index, event.currentConversation));
  }

  Stream<MessagingState> _onFetchCurrentConversationDetails(
      event, emit) async* {
    add(FetchRecentMessagesAndSubscribe(event.conversation));
    final user = await userDataRepository.getUser(event.conversation.username);
    // if (kDebugMode) {
    print(user);
    // }
    emit(ContactDetailsFetched(user, event.conversation.username));
  }

  Stream<MessagingState> _onFetchRecentMessagesAndSubscribe(
      event, emit) async* {
    try {
      emit(Initial());

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
      emit(Error(exception));
    }
  }

  Stream<MessagingState> _onFetchPreviousMessages(event, emit) async* {
    try {
      final conversationId = await messagingRepository
          .getConversationIdByUsername(event.conversation.username);
      final messages = await messagingRepository.getPreviousMessages(
          conversationId, event.lastMessage);
      emit(MessagesFetched(messages, event.conversation.username,
          isPrevious: true));
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      emit(Error(exception));
    }
  }

  void _onReceiveMessage(event, emit) {
    print(event.messages);
    emit(MessagesFetched(event.messages, event.username, isPrevious: false));
  }

  Future<void> _onSendMessage(event, emit) async {
    final message = Message(
        event.messageText,
        DateTime.now(),
        SharedObjects.preferences.getString(Constants.sessionName),
        SharedObjects.preferences.getString(Constants.sessionUsername));
    await messagingRepository.sendMessage(currentConversationId, message);
  }

// Future<void> _onPickedAttachment(event, emit) async {
//   //TODO NOT IMPLEMENTED (YET) (OR EVER)
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
