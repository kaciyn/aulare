import 'package:aulare/views/messaging/bloc/message.dart';
import 'package:aulare/views/messaging/bloc/messaging_provider.dart';
import 'package:aulare/views/rooms/components/room.dart';

class MessagingRepository {
  MessagingProvider messagingProvider = MessagingProvider();

  Stream<List<Room>> getRooms() => messagingProvider.getRooms();

  // Stream<List<Chat>> getChats() => messagingProvider.getChats();
  Stream<List<Message>> getMessages(String conversationId) =>
      messagingProvider.getMessages(conversationId);
  //
  // Future<List<Message>> getPreviousMessages(
  //         String chatId, Message prevMessage) =>
  //     messagingProvider.getPreviousMessages(chatId, prevMessage);

  // Future<List<Message>> getAttachments(String chatId, int type) =>
  //     messagingProvider.getAttachments(chatId, type);

  Future<void> sendMessage(String chatId, Message message) =>
      messagingProvider.sendMessage(chatId, message);

  // Future<String> getChatIdByUsername(String username) =>
  //     messagingProvider.getChatIdByUsername(username);
  //
  // Future<void> createChatIdForContact(User user) =>
  //     messagingProvider.createChatIdForContact(user);

  @override
  void dispose() {
    messagingProvider.dispose();
  }
}