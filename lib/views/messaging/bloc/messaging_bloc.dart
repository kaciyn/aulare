import 'dart:async';

import 'package:aulare/repositories/storage_repository.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/messaging/bloc/message.dart';
import 'package:aulare/views/messaging/bloc/messaging_event.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/bloc/messaging_state.dart';
import 'package:bloc/bloc.dart';

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
  StreamSubscription subscription;

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    print(event);
    if (event is FetchMessagesEvent) {
      mapFetchMessagesEventToState(event);
    }
    if (event is MessageReceivedEvent) {
      print(event.messages);
      yield MessagesFetchedState(event.messages);
    }
    if (event is SendMessageEvent) {
      final message =
          Message(event.message.text, DateTime.now(), 'sender', 'senderusn');
      await messagingRepository.sendMessage('conversationId', message);
    }
    // if (event is PickedAttachmentEvent) {
    //   await mapPickedAttachmentEventToState(event);
    // }
  }

  Stream<MessagingState> mapFetchMessagesEventToState(
      FetchMessagesEvent event) async* {
    try {
      yield InitialMessagingState();
      subscription?.cancel();
      subscription = messagingRepository
          .getMessages('conversationId')
          .listen((messages) => add(MessageReceivedEvent(messages)));
    } on Exception catch (exception) {
      print(exception.toString());
      yield ErrorState(exception);
    }
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
  void dispose() {
    subscription.cancel();
    super.close();
  }
}
