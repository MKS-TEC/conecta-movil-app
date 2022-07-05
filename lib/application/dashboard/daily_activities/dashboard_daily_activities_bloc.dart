import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/dashboard/daily_activities/dashboard_daily_activities_event.dart';
import 'package:conecta/application/dashboard/daily_activities/dashboard_daily_activities_state.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/event/event_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/domain/program/program_failure.dart';
import 'package:conecta/infrastructure/calendar/repositories/calendar_repository.dart';
import 'package:conecta/infrastructure/events/repositories/event_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_repository.dart';

@injectable
class DashboardDailyActivitiesBloc extends Bloc<DashboardDailyActivitiesEvent, DashboardDailyActivitiesState> {
  final ProgramRepository _programRepository;
  final PeetRepository _petRepository;
  final CalendarRepository _calendarRepository;
  final IEventRepository _iEventRepository;

  DashboardDailyActivitiesBloc(this._programRepository, this._petRepository, this._calendarRepository, this._iEventRepository) : super(Initial());

  @override
  Stream<DashboardDailyActivitiesState> mapEventToState(DashboardDailyActivitiesEvent event) async* {
    if (event is GetPrograms) {
      yield GetProgramsProcessing();
      yield* _getPrograms(event);
    } else if (event is GetCalendars) {
      yield GetCalendarsProcessing();
      yield* _getCalendars(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    } else if (event is GetEvents) {
      yield GetEventsProcessing();
      yield* _getEvents(event);
    }  if (event is GetPet) {
      yield* _getPet(event);
    }
  }

  Stream<DashboardDailyActivitiesState> _getPrograms(GetPrograms event) async* {
    var result = await _programRepository.getProgramsPet(event.petId);
    yield* result.fold(
      (ProgramFailure isLeft) async* {
        yield ProgramsNotWereLoaded(isLeft);
      }, 
      (List<Program> isRight) async* {
        yield ProgramsLoaded(isRight);
      }
    );
  }

  Stream<DashboardDailyActivitiesState> _getCalendars(GetCalendars event) async* {
    var result = await _calendarRepository.getCalendars(event.petId);
    yield* result.fold(
      (CalendarFailure isLeft) async* {
        yield CalendarsNotWereLoaded(isLeft);
      }, 
      (List<CalendarEvent> isRight) async* {
        yield CalendarsLoaded(isRight);
      }
    );
  }

  Stream<DashboardDailyActivitiesState> _getEvents(GetEvents event) async* {
    var result = await _iEventRepository.getEvents();
    yield* result.fold(
      (EventFailure isLeft) async* {
        yield EventsNotWereLoaded(isLeft);
      }, 
      (List<Event> isRight) async* {
        yield EventsLoaded(isRight);
      }
    );
  }

  Stream<DashboardDailyActivitiesState> _getPet(GetPet event) async* {
    var result = await _petRepository.getSubjectPet(event.petId);
    yield* result.fold(
      (PetFailure isLeft) async* {
        yield PetNotLoaded();
      }, 
      (Pet isRight) async* {
        yield PetLoaded(isRight);
      }
    );
  }
}