import 'package:bloc/bloc.dart';

class ChatCubit extends Cubit<int> {
  ChatCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1);
}
