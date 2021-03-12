import 'dart:async';

import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({ this.messagingRepository}) : assert(messagingRepository!=null), super(Initial());

  MessagingRepository messagingRepository;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    print(event);
    if (event is FetchConversations) {
      yield FetchingConversationInfos();
      messagingRepository.getConversationInfos().listen((conversationInfos) =>
          add(ReceiveConversationInfos(conversationInfos)));
    }
    if (event is ReceiveConversationInfos) {
      yield FetchingConversationInfos();
      yield ConversationInfosFetched(event.conversationInfos);
    }
  }
}
