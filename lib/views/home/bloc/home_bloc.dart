import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required MessagingRepository messagingRepository,
  })  : messagingRepository = messagingRepository,
        super(Initial()) {
    on<FetchConversations>((event, emit) {
      emit(FetchingConversationsInfo());
      messagingRepository.getConversationsInfo().listen((conversationInfos) =>
          add(ReceiveConversationInfo(conversationInfos)));
    });
    on<ReceiveConversationInfo>((event, emit) {
      emit(ConversationsInfoFetched()
          .copyWith(conversations: event.conversationInfos));
    });
  }

  final MessagingRepository messagingRepository;
}
