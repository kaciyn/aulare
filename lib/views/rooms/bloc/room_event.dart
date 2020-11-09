part of 'room_bloc.dart';

@immutable
abstract class RoomEvent extends Equatable {
  RoomEvent([List props = const <dynamic>[]]);
  @override
  List<Object> get props => <dynamic>[];
}

class FetchRoomListEvent extends RoomEvent {
  @override
  String toString() => 'InitialMessagingState';
}

class NewRoomReceivedEvent extends RoomEvent {
  final List<Room> conversationList = //TODO
      []; //ah i see this is all open conversations/rooms

  @override
  String toString() => 'InitialMessagingState';
}

// get details of currently open conversation, don't know if i'll ever implement
class FetchRoomDetailsEvent extends RoomEvent {
  final Room conversation;

  FetchRoomDetailsEvent(this.conversation) : super([conversation]);

  @override
  String toString() => 'InitialMessagingState';
}

class FetchRoomMessageListEvent extends RoomEvent {
  final Room
      conversation; //this needs to actually get messages later also whyyyy is this empty and the below one has what i think should be in this one???? WHY

  FetchRoomMessageListEvent(this.conversation) : super([conversation]);

  @override
  String toString() => 'InitialMessagingState';
}

class PageUpdatedEvent extends RoomEvent {
  final int index;

  final Room activeRoom;

  PageUpdatedEvent(this.index, this.activeRoom) : super([index, activeRoom]);

  @override
  String toString() => 'InitialMessagingState';
}
