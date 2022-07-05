
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/program/program_view_event.dart';
import 'package:conecta/application/program/program_view_state.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/program/program_failure.dart';
import 'package:conecta/infrastructure/calendar/repositories/calendar_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_repository.dart';

@injectable
class ProgramViewBloc extends Bloc<ProgramViewEvent, ProgramViewState> {
  final ProgramRepository _programRepository;
  final PeetRepository _petRepository;
  final CalendarRepository _calendarRepository;

  ProgramViewBloc(this._programRepository, this._petRepository, this._calendarRepository) : super(Initial());

  @override
  Stream<ProgramViewState> mapEventToState(ProgramViewEvent event) async* {
    if (event is GetProgram) {
      yield* _getProgram(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    }
  }

  Stream<ProgramViewState> _getCalendars(GetCalendars event) async* {
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

  Stream<ProgramViewState> _getProgram(GetProgram event) async* {
    var result = await _programRepository.getProgramPet(event.petId, event.programId);
    yield* result.fold(
      (ProgramFailure isLeft) async* {
        yield ProgramNotLoaded();
      }, 
      (Program isRight) async* {
        yield ProgramLoaded(isRight);
        var resultLoadPrograms = await _calendarRepository.getCalendarsByProgram(event.petId, event.programId);
        yield* resultLoadPrograms.fold(
          (CalendarFailure failure) async* {
            yield CalendarsNotWereLoaded(failure);
          }, 
          (List<CalendarEvent> calendarEvents) async* {
            yield CalendarsLoaded(calendarEvents);
          }
        );
      }
    );
  }
}