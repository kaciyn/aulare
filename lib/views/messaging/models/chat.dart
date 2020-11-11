class Chat {
  Chat(this.username, this.chatId);

  @override
  String toString() => '{ username= $username, chatId = $chatId}';

  String username;
  String chatId;
}
//TODO i really don't see why this a different thing than conversation
