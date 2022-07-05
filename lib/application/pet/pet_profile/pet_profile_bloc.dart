



import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/pet/pet_profile/pet_profile_event.dart';
import 'package:conecta/application/pet/pet_profile/pet_profile_state.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/pet/breed_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/infrastructure/app_events/repositories/app_event_repositories.dart';
import 'package:conecta/infrastructure/challenges/repositories/challenges_repositories.dart';
import 'package:conecta/infrastructure/pet/breed_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/pet_points/repositories/pet_points_repository.dart';

@injectable
class PetProfileBloc extends Bloc<PetProfileEvent, PetProfileState> {
  final PeetRepository _petRepository;
  final BreedRepository _breedRepository;
  final IChallengeRepository _iChallengeRepository;
  final IPetPointRepository _iPetPointRepository;
  final IAppEventRepository _iAppEventRepository;

  PetProfileBloc(this._petRepository, this._breedRepository, this._iAppEventRepository, this._iChallengeRepository, this._iPetPointRepository) : super(Initial());

  @override
  Stream<PetProfileState> mapEventToState(PetProfileEvent event) async* {
    if (event is GetPet) {
      yield* _getPet(event);
    } else if (event is UpdatePet) {
      yield UpdatePetProcessing();
      yield* _updatePet(event);
    } else if (event is GetBreedsBySpecies) {
      yield GetBreedsProcessing();
      yield* _getBreedsBySpecies(event);
    } else if (event is GetOwnerChallenges) {
      yield GetChallengesOwnerProcessing();
      yield* _getOwnerChallenges(event);
    } else if (event is UpdateChallenge) {
      yield UpdateChallengeProcessing();
      yield* _updateChallenge(event);
    } else if (event is UpdateChallengeActivity) {
      yield UpdateChallengeActivityProcessing();
      yield* _updateChallengeActivity(event);
    } else if (event is UpdatePetPoints) {
      yield UpdatePetPointsProcessing();
      yield* _updatePetPoints(event);
    } else if (event is CreateAppEvent) {
      yield CreateAppEventProcessing();
      yield* _createAppEvent(event);
    } else if (event is GetAppEvents) {
      yield GetAppEventsProcessing();
      yield* _getAppEvents(event);
    } 
  }

  Stream<PetProfileState> _getPet(GetPet event) async* {
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

  Stream<PetProfileState> _updatePet(UpdatePet event) async* {
    var result = await _petRepository.updateSubjectPet(event.pet);
    yield* result.fold(
      (PetFailure isLeft) async* {
        yield FailuredUpdatePet(isLeft);
      }, 
      (Pet isRight) async* {
        yield SuccessfulUpdatePet(isRight);
      }
    );
  }

  Stream<PetProfileState> _getBreedsBySpecies(GetBreedsBySpecies event) async* {
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

  Stream<PetProfileState> _getOwnerChallenges(GetOwnerChallenges event) async* {
    var result = await _iChallengeRepository.getChallengesOwner(event.ownerId);
    yield* result.fold(
      (ChallengeFailure isLeft) async* {
        yield ChallengesOwnerNotWereLoaded(isLeft);
      }, 
      (List<Challenge> isRight) async* {
        yield ChallengesOwnerLoaded(isRight);
      }
    );
  }

  Stream<PetProfileState> _updateChallenge(UpdateChallenge event) async* {
    var result = await _iChallengeRepository.updateStatusChallengeOwner(event.ownerId, event.challengeId);
    yield* result.fold(
      (ChallengeFailure isLeft) async* {
        yield FailuredUpdateChallenge(isLeft);
      }, 
      (Unit isRight) async* {
        yield SuccessfulUpdateChallenge();
      }
    );
  }

  Stream<PetProfileState> _updateChallengeActivity(UpdateChallengeActivity event) async* {
    var result = await _iChallengeRepository.updateStatusChallengeActivityOwner(event.ownerId, event.challengeId, event.challengeActivity);
    yield* result.fold(
      (ChallengeFailure isLeft) async* {
        yield FailuredUpdateChallengeActivity(isLeft);
      }, 
      (ChallengeActivity isRight) async* {
        yield SuccessfulUpdateChallengeActivity(isRight);
      }
    );
  }

  Stream<PetProfileState> _updatePetPoints(UpdatePetPoints event) async* {
    var result = await _iPetPointRepository.updatePetPoints(event.ownerId, event.petPointsQuantity);
    yield* result.fold(
      (PetPointFailure isLeft) async* {
        yield FailuredUpdatePetPoints(isLeft);
      }, 
      (Unit isRight) async* {
        yield SuccessfulUpdatePetPoints();
      }
    );
  }

  Stream<PetProfileState> _createAppEvent(CreateAppEvent event) async* {
    var result = await _iAppEventRepository.createAppEvent(event.ownerId, event.appEvent);
    yield* result.fold(
      (AppEventFailure isLeft) async* {
        yield FailuredCreateAppEvent();
      }, 
      (AppEvent isRight) async* {
        yield SuccessfulCreateAppEvent(isRight);
      }
    );
  }

  Stream<PetProfileState> _getAppEvents(GetAppEvents event) async* {
    var result = await _iAppEventRepository.getAppEvents(event.ownerId);
    yield* result.fold(
      (AppEventFailure isLeft) async* {
        yield AppEventsNotWereLoaded(isLeft);
      }, 
      (List<AppEvent> isRight) async* {
        yield AppEventsLoaded(isRight);
      }
    );
  }
}