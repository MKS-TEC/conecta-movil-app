

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/vaccines/vaccines_event.dart';
import 'package:conecta/application/vaccines/vaccines_state.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/vaccine.dart';
import 'package:conecta/domain/program/program_failure.dart';
import 'package:conecta/domain/vaccine/vaccine_failure.dart';
import 'package:conecta/infrastructure/calendar/repositories/calendar_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_repository.dart';
import 'package:conecta/infrastructure/vaccines/repositories/vaccines_repositories.dart';

@injectable
class VaccinesBloc extends Bloc<VaccinesEvent, VaccinesState> {
  final VaccinesRepository _vaccinesRepository;
  final PeetRepository _petRepository;
  final CalendarRepository _calendarRepository;
  final ProgramRepository _programRepository;

  VaccinesBloc(this._vaccinesRepository, this._petRepository, this._programRepository, this._calendarRepository) : super(Initial());

  @override
  Stream<VaccinesState> mapEventToState(VaccinesEvent event) async* {
    if (event is GetVaccines) {
      yield* _getVaccines(event);
    } else if (event is CreateVaccine) {
      yield CreateVaccineProcessing();
      yield* _createVaccine(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    } else if (event is GetCalendars) {
      yield GetCalendarsProcessing();
      yield* _getCalendars(event);
    } else if (event is GetPrograms) {
      yield GetProgramsProcessing();
      yield* _getPrograms(event);
    }
  }

  Stream<VaccinesState> _getVaccines(GetVaccines event) async* {
    var result = await _vaccinesRepository.getVaccines(event.petId);
    yield* result.fold(
      (VaccineFailure isLeft) async* {
        yield VaccinesNotWereLoaded();
      }, 
      (List<Vaccine> isRight) async* {
        yield VaccinesLoaded(isRight);
      }
    );
  }

  Stream<VaccinesState> _getPrograms(GetPrograms event) async* {
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

  Stream<VaccinesState> _createVaccine(CreateVaccine event) async* {
    var result = await _vaccinesRepository.createVaccine(event.petId, event.vaccine);
    yield* result.fold(
      (VaccineFailure isLeft) async* {
        yield FailuredCreateVaccine(isLeft);
      }, 
      (Vaccine isRight) async* {
        yield SuccessfulCreateVaccine(isRight);
      }
    );
  }

  Stream<VaccinesState> _getCalendars(GetCalendars event) async* {
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