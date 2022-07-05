import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/owner/pets/owner_pets_event.dart';
import 'package:conecta/application/owner/pets/owner_pets_state.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';

@injectable
class OwnerPetsBloc extends Bloc<OwnerPetsEvent, OwnerPetsState> {
  final PeetRepository _petRepository;

  OwnerPetsBloc(this._petRepository) : super(Initial());

  @override
  Stream<OwnerPetsState> mapEventToState(OwnerPetsEvent event) async* {
    if (event is GetSubjectPets) {
      yield* _getSubjectPets(event);
    }
  }

  Stream<OwnerPetsState> _getSubjectPets(GetSubjectPets event) async* {
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