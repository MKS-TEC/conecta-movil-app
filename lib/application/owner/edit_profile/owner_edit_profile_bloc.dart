import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/owner/edit_profile/owner_edit_profile_event.dart';
import 'package:conecta/application/owner/edit_profile/owner_edit_profile_state.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/core/entities/country.dart';
import 'package:conecta/domain/owner/owner_failure.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/infrastructure/app_events/repositories/app_event_repositories.dart';
import 'package:conecta/infrastructure/challenges/repositories/challenges_repositories.dart';
import 'package:conecta/infrastructure/owner/repositories/owner_repository.dart';
import 'package:conecta/infrastructure/pet_points/repositories/pet_points_repository.dart';

@injectable
class OwnerEditProfileBloc extends Bloc<OwnerEditProfileEvent, OwnerEditProfileState> {
  final OwnerRepository _ownerRepository;
  final IChallengeRepository _iChallengeRepository;
  final IPetPointRepository _iPetPointRepository;
  final IAppEventRepository _iAppEventRepository;

  OwnerEditProfileBloc(this._ownerRepository, this._iChallengeRepository, this._iAppEventRepository, this._iPetPointRepository) : super(Initial());

  @override
  Stream<OwnerEditProfileState> mapEventToState(OwnerEditProfileEvent event) async* {
    if (event is GetOwner) {
      yield* _getOwner(event);
    } else if (event is UpdateOwner) {
      yield UpdateOwnerProcessing();
      yield* _updateOwner(event);
    } else if(event is GetCountries){
      yield* _getCountries(event);
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

  Stream<OwnerEditProfileState> _getOwner(GetOwner event) async* {
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

  Stream<OwnerEditProfileState> _updateOwner(UpdateOwner event) async* {
    var result = await _ownerRepository.updateSubjectOwner(event.owner);
    yield* result.fold(
      (OwnerFailure isLeft) async* {
        yield FailuredUpdateOwner();
      }, 
      (Owner isRight) async* {
        yield SuccessfulUpdateOwner();
      }
    );
  }

  Stream<OwnerEditProfileState> _getCountries(GetCountries event) async* {
    var result = await _ownerRepository.getCountries();
    yield* result.fold(
      (OwnerFailure isLeft) async* {
        yield CountriesNotLoaded();
      }, 
      (List<Country> isRight) async* {
        yield CountriesLoaded(isRight);
      }
    );
  }

  Stream<OwnerEditProfileState> _getOwnerChallenges(GetOwnerChallenges event) async* {
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

  Stream<OwnerEditProfileState> _updateChallenge(UpdateChallenge event) async* {
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

  Stream<OwnerEditProfileState> _updateChallengeActivity(UpdateChallengeActivity event) async* {
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

  Stream<OwnerEditProfileState> _updatePetPoints(UpdatePetPoints event) async* {
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

  Stream<OwnerEditProfileState> _createAppEvent(CreateAppEvent event) async* {
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

  Stream<OwnerEditProfileState> _getAppEvents(GetAppEvents event) async* {
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