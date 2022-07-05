import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/pet/create_pet/create_pet_event.dart';
import 'package:conecta/application/pet/create_pet/create_pet_state.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/program_category.dart';
import 'package:conecta/domain/core/entities/species.dart';
import 'package:conecta/domain/pet/breed_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/domain/pet/species_failure.dart';
import 'package:conecta/domain/program/program_category_failure.dart';
import 'package:conecta/domain/program/program_failure.dart';
import 'package:conecta/infrastructure/calendar/repositories/calendar_repository.dart';
import 'package:conecta/infrastructure/pet/breed_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/pet/species_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_category_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_repository.dart';

@injectable
class CreatePetBloc extends Bloc<CreatePetEvent, CreatePetState> {
  final SpeciesRepository _speciesRepository;
  final BreedRepository _breedRepository;
  final ProgramRepository _programRepository;
  final ProgramCategoryRepository _programCategoryRepository;
  final PeetRepository _peetRepository;
  final CalendarRepository _calendarRepository;

  CreatePetBloc(this._speciesRepository, this._breedRepository, this._programRepository, this._programCategoryRepository, this._calendarRepository, this._peetRepository) : super(Initial());

  @override
  Stream<CreatePetState> mapEventToState(
    CreatePetEvent event,
  ) async* {
    if (event is GetSpecies) {
      yield GetSpeciesProcessing();
      yield* _getSpecies(event);
    } else if (event is GetBreedsBySpecies) {
      yield GetBreedsProcessing();
      yield* _getBreedsBySpecies(event);
    } else if (event is SetPet) {
      yield SetPetProcessing();
      yield* _setPet(event);
    } else if (event is GetPrograms) {
      yield GetProgramsProcessing();
      yield* _getPrograms(event);
    } else if (event is CreatePrograms) {
      yield CreateProgramsProcessing();
      yield* _createPrograms(event);
    } else if (event is CreateCalendar) {
      yield CreateCalendarProcessing();
      yield* _createCalendar(event);
    }
  }

  Stream<CreatePetState> _getSpecies(GetSpecies event) async* {
    var result = await _speciesRepository.getSpecies();
    yield* result.fold(
      (SpeciesFailure isLeft) async* {
        yield SpeciesNotWereLoaded(isLeft);
      }, 
      (List<Species> isRight) async* {
        yield SpeciesLoaded(isRight);
      }
    );
  }

  Stream<CreatePetState> _getBreedsBySpecies(GetBreedsBySpecies event) async* {
    var result = await _breedRepository.getBreedsBySpecies(event.species);
    yield* result.fold(
      (BreedFailure isLeft) async* {
        yield BreedsNotWereLoaded(isLeft);
      }, 
      (List<Breed> isRight) async* {
        yield BreedsLoaded(isRight);
      }
    );
  }

  Stream<CreatePetState> _setPet(SetPet event) async* {
    var result = await _peetRepository.setPet(event.pet);
    yield* result.fold(
      (PetFailure isLeft) async* {
        yield FailuredSetPet(isLeft);
      }, 
      (Pet isRight) async* {
        yield SuccessfulSetPet(isRight);
      }
    );
  }

  Stream<CreatePetState> _getPrograms(GetPrograms event) async* {
    var programCategoriesResult = await _programCategoryRepository.getProgramCategories();

    yield* programCategoriesResult.fold(
      (ProgramCategoryFailure isLeft) async* {
        yield ProgramsNotWereLoaded();
      }, 
      (List<ProgramCategory> isRight) async* {
        List<Program> _programs = [];

        await Future.forEach(isRight, (ProgramCategory programCategory) async {
          Program? _program = await _getProgramByCategoryAndPet(programCategory.name, event.pet);

          if (_program != null) _programs.add(_program);
        });

        yield ProgramsLoaded(_programs);
      }
    );
  }

  Future<Program?> _getProgramByCategoryAndPet(String programCategory, Pet pet) async {
    Map<String, String> _filters = {
      "breed": pet.breed!,
      "species": pet.species!,
    };

    var result = await _programRepository.getProgramsByFilters(programCategory, _filters);

    if (result.isRight()) {
      List<Program> programs = result.getOrElse(() => <Program>[]);

      if (programs.length > 0) return programs[0];

      _filters = {
        "breed": "All",
        "species": pet.species!,
      };

      result = await _programRepository.getProgramsByFilters(programCategory, _filters);

      if (result.isRight()) {
        programs = result.getOrElse(() => <Program>[]);

        return programs.length > 0 ? programs[0] : null;
      }
    }
  }

  Stream<CreatePetState> _createPrograms(CreatePrograms event) async* {
    for (var i = 0; i < event.programs.length; i++) {
      await _programRepository.createProgram(event.petId, event.programs[i]);
    }

    yield SuccessfulCreatePrograms();
  }

   Stream<CreatePetState> _createCalendar(CreateCalendar event) async* {
    await _calendarRepository.createCalendar(event.petId, event.calendarEvents);
    yield SuccessfulCreateCalendar();
  }
}