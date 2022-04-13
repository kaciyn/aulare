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

// on<ReceiveMessage>((event, emit) {
//   print(event.messages);
//   emit(MessagesFetched().copyWith(
//       messages: event.messages,
//       contactUsername: event.contactUsername,
//       isPrevious: false));
// });

// Future<void> _onSendMessage(event, emit) async {
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
// }
