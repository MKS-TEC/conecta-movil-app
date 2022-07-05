import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/pathologies/pathologies_event.dart';
import 'package:conecta/application/pathologies/pathologies_state.dart';
import 'package:conecta/domain/core/entities/pathology.dart';
import 'package:conecta/domain/pathology/pathology_failure.dart';
import 'package:conecta/infrastructure/pathologies/repositories/episodes_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';

@injectable
class PathologiesBloc extends Bloc<PathologiesEvent, PathologiesState> {
  final PathologiesRepository _pathologiesRepository;
  final PeetRepository _petRepository;

  PathologiesBloc(this._pathologiesRepository, this._petRepository) : super(Initial());

  @override
  Stream<PathologiesState> mapEventToState(PathologiesEvent event) async* {
    if (event is GetPathologies) {
      yield* _getPathologies(event);
    } else if (event is CreatePathology) {
      yield CreatePathologyProcessing();
      yield* _createPathology(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    }
  }

  Stream<PathologiesState> _getPathologies(GetPathologies event) async* {
    var result = await _pathologiesRepository.getPathologies(event.petId);
    yield* result.fold(
      (PathologyFailure isLeft) async* {
        yield PathologiesNotWereLoaded();
      }, 
      (List<Pathology> isRight) async* {
        yield PathologiesLoaded(isRight);
      }
    );
  }

  Stream<PathologiesState> _createPathology(CreatePathology event) async* {
    var result = await _pathologiesRepository.createPathology(event.petId, event.pathology);
    yield* result.fold(
      (PathologyFailure isLeft) async* {
        yield FailuredCreatePathology(isLeft);
      }, 
      (Pathology isRight) async* {
        yield SuccessfulCreatePathology(isRight);
      }
    );
  }
}