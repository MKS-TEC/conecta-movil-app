import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/owner/profile/owner_profile_event.dart';
import 'package:conecta/application/owner/profile/owner_profile_state.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/owner/owner_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/infrastructure/owner/repositories/owner_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';

@injectable
class OwnerProfileBloc extends Bloc<OwnerProfileEvent, OwnerProfileState> {
  final OwnerRepository _ownerRepository;
  final PeetRepository _petRepository;

  OwnerProfileBloc(this._ownerRepository, this._petRepository) : super(Initial());

  @override
  Stream<OwnerProfileState> mapEventToState(OwnerProfileEvent event) async* {
    if (event is GetOwner) {
      yield* _getOwner(event);
    } else if(event is GetOwnerPets){
      yield* _getOwnerPets(event);
    }
  }

  Stream<OwnerProfileState> _getOwner(GetOwner event) async* {
    var result = await _ownerRepository.getOwner(event.ownerId);
    yield* result.fold(
      (OwnerFailure isLeft) async* {
        yield OwnerNotLoaded();
      }, 
      (Owner isRight) async* {
        yield OwnerLoaded(isRight);
      }
    );
  }
 
  Stream<OwnerProfileState> _getOwnerPets(GetOwnerPets event) async* {
    var result = await _petRepository.getSubjectPets(event.ownerId);
    yield* result.fold(
      (PetFailure isLeft) async* {
        yield OwnerPetsNotLoaded();
      }, 
      (List<Pet> isRight) async* {
        yield OwnerPetsLoaded(isRight);
      }
    );
  }
 
}