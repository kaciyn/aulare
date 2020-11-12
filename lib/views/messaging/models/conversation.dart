class Conversation {
  Conversation(this.username, this.conversationId);

  @override
  String toString() => '{ username= $username, chatId = $conversationId}';

  String username;
  String conversationId;
}
//TODO i really don't see why this a different thing than conversation
