import 'dart:async';

import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({this.messagingRepository})
      : assert(messagingRepository != null),
        super(Initial()) {
    on<FetchConversations>(_onFetchConversations);
    on<ReceiveConversationInfo>(_onReceiveConversationInfo);
  }

  MessagingRepository messagingRepository;

  void _onFetchConversations(event, emit) {
    emit(FetchingConversationInfo());
    messagingRepository.getConversationInfos().listen(
        (conversationInfos) => add(ReceiveConversationInfo(conversationInfos)));
  }

  void _onReceiveConversationInfo(event, emit) {
    emit(FetchingConversationInfo());
    emit(ConversationInfosFetched(event.conversationInfos));
  }
}
