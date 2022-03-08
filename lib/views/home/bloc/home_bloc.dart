
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({this.messagingRepository})
      : super(Initial()) {
    on<FetchConversations>(_onFetchConversations);
    on<ReceiveConversationInfo>(_onReceiveConversationsInfo);
  }

  MessagingRepository? messagingRepository;

  void _onFetchConversations(event, emit) {
    emit(FetchingConversationsInfo());
    messagingRepository!.getConversationsInfo().listen(
        (conversationInfos) => add(ReceiveConversationInfo(conversationInfos)));
  }

  void _onReceiveConversationsInfo(event, emit) {
    emit(FetchingConversationsInfo());
    emit(ConversationsInfoFetched(event.conversationInfos));
  }
}
