import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/dashboard/dashboard_event.dart';
import 'package:conecta/application/dashboard/dashboard_state.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final PeetRepository _petRepository;

  DashboardBloc(this._petRepository) : super(Initial());

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is GetSubjectPets) {
      yield* _getSubjectPets(event);
    } else if (event is SetPetDefault) {
      await _petRepository.setPetDefault(event.petId);
      yield SuccessfulSetPet(event.petId);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    }
  }

  Stream<DashboardState> _getSubjectPets(GetSubjectPets event) async* {
    var result = await _petRepository.getSubjectPets(event.uid);
    yield* result.fold(
      (PetFailure isLeft) async* {
        yield SubjectPetsNotWereLoaded();
      }, 
      (List<Pet> isRight) async* {
        yield SubjectPetsLoaded(isRight);
      }
    );
  }

}