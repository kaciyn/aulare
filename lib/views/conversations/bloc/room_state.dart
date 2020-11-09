part of 'conversation_bloc.dart';

@immutable
abstract class RoomState extends Equatable {
  @override
  List<Object> get props => [];

  const RoomState([List props = const <dynamic>[]]);
}

class RoomInitial extends RoomState {}

class ErrorState extends RoomState {
  ErrorState(this.exception) : super([exception]);
  final AulareException exception;

  @override
  String toString() => 'ErrorState';
}
