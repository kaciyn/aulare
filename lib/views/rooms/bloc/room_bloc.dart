import 'dart:async';

import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/views/rooms/components/room.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  RoomBloc() : super(RoomInitial());

  @override
  Stream<RoomState> mapEventToState(
    RoomEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
