

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/weights/weights_event.dart';
import 'package:conecta/application/weights/weights_state.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/weight.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/domain/weight/weight_failure.dart';
import 'package:conecta/infrastructure/app_events/repositories/app_event_repositories.dart';
import 'package:conecta/infrastructure/challenges/repositories/challenges_repositories.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/pet_points/repositories/pet_points_repository.dart';
import 'package:conecta/infrastructure/weight/repositories/weight_repository.dart';

@injectable
class WeightsBloc extends Bloc<WeightsEvent, WeightsState> {
  final WeightsRepository _weightsRepository;
  final PeetRepository _petRepository;
  final IChallengeRepository _iChallengeRepository;
  final IPetPointRepository _iPetPointRepository;
  final IAppEventRepository _iAppEventRepository;

  WeightsBloc(this._weightsRepository, this._iChallengeRepository, this._iAppEventRepository, this._iPetPointRepository, this._petRepository) : super(Initial());

  @override
  Stream<WeightsState> mapEventToState(WeightsEvent event) async* {
    if (event is GetWeights) {
      yield* _getWeights(event);
    } else if (event is CreateWeight) {
      yield CreateWeightProcessing();
      yield* _createWeight(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
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

  Stream<WeightsState> _getWeights(GetWeights event) async* {
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

  Stream<WeightsState> _createWeight(CreateWeight event) async* {
    var result = await _weightsRepository.createWeight(event.petId, event.weight);
    yield* result.fold(
      (WeightFailure isLeft) async* {
        yield FailuredCreateWeight(isLeft);
      }, 
      (Weight isRight) async* {
        yield SuccessfulCreateWeight(isRight);
      }
    );
  }

  Stream<WeightsState> _getOwnerChallenges(GetOwnerChallenges event) async* {
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

  Stream<WeightsState> _updateChallenge(UpdateChallenge event) async* {
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

  Stream<WeightsState> _updateChallengeActivity(UpdateChallengeActivity event) async* {
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

  Stream<WeightsState> _updatePetPoints(UpdatePetPoints event) async* {
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

  Stream<WeightsState> _createAppEvent(CreateAppEvent event) async* {
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

  Stream<WeightsState> _getAppEvents(GetAppEvents event) async* {
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