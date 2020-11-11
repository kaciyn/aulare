import 'package:aulare/models/user.dart';
import 'package:aulare/views/messaging/bloc/messaging_provider.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:aulare/views/messaging/models/message.dart';

class MessagingRepository {
  MessagingProvider messagingProvider = MessagingProvider();

  Stream<List<Conversation>> getConversations() =>
      messagingProvider.getConversations();

  Stream<List<Message>> getMessages(String conversationId) =>
      messagingProvider.getMessages(conversationId);

  Future<List<Message>> getPreviousMessages(
          String conversationId, Message prevMessage) =>
      messagingProvider.getPreviousMessages(conversationId, prevMessage);

  // Future<List<Message>> getAttachments(String conversationId, int type) =>
  //     messagingProvider.getAttachments(conversationId, type);

  Future<void> sendMessage(String conversationId, Message message) =>
      messagingProvider.sendMessage(conversationId, message);

  Future<String> getConversationIdByUsername(String username) =>
      messagingProvider.getConversationIdByUsername(username);

  Future<void> createConversationIdForContact(User user) =>
      messagingProvider.createConversationIdForContact(user);

  @override
  void dispose() {
    messagingProvider.dispose();
  }
}
