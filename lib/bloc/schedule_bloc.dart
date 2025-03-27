// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:trash_crew/models/schedule_model.dart';
// import 'package:trash_crew/views/Schedule.dart';

// // Define the base class for all user-related events.
// abstract class ScheduleEvent {
//   ScheduleEvent(PickupRequest pickup);
// }

// // Event to set a new user.
// class SetScheduleEvent extends ScheduleEvent {
//   final Schedule schedule;

//   SetScheduleEvent(this.schedule) : super(PickupRequest());
// }

// // Define the base class for all Schedule-related states.
// abstract class ScheduleState {}

// // Initial state when no Schedule is loaded.
// class ScheduleInitial extends ScheduleState {}

// // State representing a loaded Schedule.
// class SckeduleLoaded extends ScheduleState {
//   final Schedule schedule;

//   SckeduleLoaded(this.schedule);
// }

// // Bloc to handle Schedule events and manage Schedule states.
// class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
//   ScheduleBloc() : super (ScheduleInitial()) {
//     // Handle the SetScheduleEvent by emitting a SckeduleLoaded state.
//     on<SetScheduleEvent>((event, emit) {
//       emit(SckeduleLoaded(event.schedule));
//     });
//   }
// }
