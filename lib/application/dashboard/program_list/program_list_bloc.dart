import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/dashboard/program_list/program_list_event.dart';
import 'package:conecta/application/dashboard/program_list/program_list_state.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/program/program_failure.dart';
import 'package:conecta/infrastructure/calendar/repositories/calendar_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_repository.dart';

@injectable
class ProgramListBloc extends Bloc<ProgramListEvent, ProgramListState> {
  final ProgramRepository _programRepository;
  final PeetRepository _petRepository;
  final CalendarRepository _calendarRepository;

  ProgramListBloc(this._programRepository, this._petRepository, this._calendarRepository) : super(Initial());

  @override
  Stream<ProgramListState> mapEventToState(ProgramListEvent event) async* {
    if (event is GetPrograms) {
      yield GetProgramsProcessing();
      yield* _getPrograms(event);
    } else if (event is GetCalendars) {
      yield GetCalendarsProcessing();
      yield* _getCalendars(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    }
  }

  Stream<ProgramListState> _getPrograms(GetPrograms event) async* {
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

  Stream<ProgramListState> _getCalendars(GetCalendars event) async* {
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
}