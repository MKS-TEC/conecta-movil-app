



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/diagnosis/diagnosis_event.dart';
import 'package:conecta/application/diagnosis/diagnosis_state.dart';
import 'package:conecta/domain/core/entities/diagnose.dart';
import 'package:conecta/domain/diagnosis/diagnosis_failure.dart';
import 'package:conecta/infrastructure/diagnosis/repositories/diagnosis_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';

@injectable
class DiagnosisBloc extends Bloc<DiagnosisEvent, DiagnosisState> {
  final DiagnosisRepository _diagnosisRepository;
  final PeetRepository _petRepository;

  DiagnosisBloc(this._diagnosisRepository, this._petRepository) : super(Initial());

  @override
  Stream<DiagnosisState> mapEventToState(DiagnosisEvent event) async* {
    if (event is GetDiagnosis) {
      yield* _getDiagnosis(event);
    } else if (event is CreateDiagnose) {
      yield CreateDiagnoseProcessing();
      yield* _createDiagnose(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    }
  }

  Stream<DiagnosisState> _getDiagnosis(GetDiagnosis event) async* {
    var result = await _diagnosisRepository.getDiagnosis(event.petId);
    yield* result.fold(
      (DiagnosisFailure isLeft) async* {
        yield DiagnosisNotWereLoaded();
      }, 
      (List<Diagnose> isRight) async* {
        yield DiagnosisLoaded(isRight);
      }
    );
  }

  Stream<DiagnosisState> _createDiagnose(CreateDiagnose event) async* {
    var result = await _diagnosisRepository.createDiagnose(event.petId, event.diagnose);
    yield* result.fold(
      (DiagnosisFailure isLeft) async* {
        yield FailuredCreateDiagnose(isLeft);
      }, 
      (Diagnose isRight) async* {
        yield SuccessfulCreateDiagnose(isRight);
      }
    );
  }
}