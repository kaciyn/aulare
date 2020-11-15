part of 'google_bloc.dart';

abstract class GoogleState extends Equatable {
  const GoogleState();
}

class GoogleInitial extends GoogleState {
  @override
  List<Object> get props => [];
}
