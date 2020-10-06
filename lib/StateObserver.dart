import 'package:bloc/bloc.dart';

/// [BlocObserver] for the application which
/// observes all [Cubit] state changes.

class StateObserver extends BlocObserver {//TODO change name to something better when you figure out what this does
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} $change'); //overrides onChange to print any state change
    super.onChange(cubit, change);
  }
}
