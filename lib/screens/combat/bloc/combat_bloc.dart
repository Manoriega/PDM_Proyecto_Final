import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'combat_event.dart';
part 'combat_state.dart';

class CombatBloc extends Bloc<CombatEvent, CombatState> {
  CombatBloc() : super(CombatInitial()) {
    on<CombatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
