import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/dashboard/medical_history/dashboard_medical_history_event.dart';
import 'package:conecta/application/dashboard/medical_history/dashboard_medical_history_state.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/weight.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/domain/weight/weight_failure.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/weight/repositories/weight_repository.dart';

@injectable
class DashboardMedicalHistoryBloc extends Bloc<DashboardMedicalHistoryEvent, DashboardMedicalHistoryState> {
  final PeetRepository _petRepository;
  final WeightsRepository _weightsRepository;

  DashboardMedicalHistoryBloc(this._petRepository, this._weightsRepository) : super(Initial());

  @override
  Stream<DashboardMedicalHistoryState> mapEventToState(DashboardMedicalHistoryEvent event) async* {
    if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    } else if (event is GetPet) {
      yield* _getPet(event);
    } else if (event is GetWeights) {
      yield* _getWeights(event);
    }
  }

  Stream<DashboardMedicalHistoryState> _getPet(GetPet event) async* {
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

  Stream<DashboardMedicalHistoryState> _getWeights(GetWeights event) async* {
    var result = await _weightsRepository.getWeights(event.petId);
    yield* result.fold(
      (WeightFailure isLeft) async* {
        yield WeightsNotWereLoaded();
      }, 
      (List<Weight> isRight) async* {
        yield WeightsLoaded(isRight);
      }
    );
  }
}