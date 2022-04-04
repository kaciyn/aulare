class Conversation {
  Conversation(this.contactUsername, this.conversationId);

  @override
  String toString() =>
      '{ username= $contactUsername, chatId = $conversationId}';

  String contactUsername;
  String? conversationId;
}
// i really don't see why this a different thing than conversation
