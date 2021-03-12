import 'package:bloc/bloc.dart';

/// [BlocObserver] for the application which
/// observes all [Cubit] state changes.

class StateObserver extends BlocObserver {
  //TODO change name to something better when you figure out what this does
  @override
  void onChange(Cubit cubit, Change change) {
    print(
        '${cubit.runtimeType} $change'); //overrides onChange to print any state change
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  Future<void> onError(Cubit cubit, Object error, StackTrace stacktrace) async {
    super.onError(cubit, error, stacktrace);
    print(error);
  }
}
