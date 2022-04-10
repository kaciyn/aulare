part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState({
    this.conversations,
  });

  List<Conversation>? conversations;

  HomeState copyWith({List<Conversation>? conversations}) {
    return HomeState(
      conversations: conversations ?? this.conversations,
    );
  }

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class Initial extends HomeState {}

class FetchingConversationsInfo extends HomeState {
  @override
  String toString() => 'FetchingConversations';
}

class ConversationsInfoFetched extends HomeState {
  ConversationsInfoFetched({
    this.conversations,
  });

  List<Conversation>? conversations;

  ConversationsInfoFetched copyWith({List<Conversation>? conversations}) {
    return ConversationsInfoFetched(
      conversations: conversations ?? this.conversations,
    );
  }

  @override
  String toString() => 'ConversationsFetched';
}
