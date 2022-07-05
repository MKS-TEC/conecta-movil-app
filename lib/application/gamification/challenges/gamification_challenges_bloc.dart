import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/gamification/challenges/gamification_challenges_event.dart';
import 'package:conecta/application/gamification/challenges/gamification_challenges_state.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/infrastructure/app_events/repositories/app_event_repositories.dart';
import 'package:conecta/infrastructure/challenges/repositories/challenges_repositories.dart';
import 'package:conecta/infrastructure/pet_points/repositories/pet_points_repository.dart';

@injectable
class GamificationChallengesBloc extends Bloc<GamificationChallengesEvent, GamificationChallengesState> {
  final IChallengeRepository _iChallengeRepository;
  final IAppEventRepository _iAppEventRepository;
  final IPetPointRepository _iPetPointRepository;

  GamificationChallengesBloc(this._iChallengeRepository, this._iPetPointRepository, this._iAppEventRepository) : super(Initial());

  @override
  Stream<GamificationChallengesState> mapEventToState(GamificationChallengesEvent event) async* {
    if (event is GetChallenges) {
      yield GetChallengesProcessing();
      yield* _getChallenges(event);
    } else if (event is GetOwnerChallenges) {
      yield GetChallengesOwnerProcessing();
      yield* _getOwnerChallenges(event);
    } else if (event is CreateChallenge) {
      yield CreateChallengeProcessing();
      yield* _createChallenge(event);
    } else if (event is GetAppEvents) {
      yield GetAppEventsProcessing();
      yield* _getAppEvents(event);
    } else if (event is UpdateChallenge) {
      yield UpdateChallengeProcessing();
      yield* _updateChallenge(event);
    } else if (event is UpdateChallengeActivities) {
      yield UpdateChallengeActivitiesProcessing();
      yield* _updateActivities(event);
    } else if (event is UpdatePetPoints) {
      yield UpdatePetPointsProcessing();
      yield* _updatePetPoints(event);
    }
  }

  Stream<GamificationChallengesState> _getChallenges(GetChallenges event) async* {
    var result = await _iChallengeRepository.getChallenges();
    yield* result.fold(
      (ChallengeFailure isLeft) async* {
        yield ChallengesNotWereLoaded(isLeft);
      }, 
      (List<Challenge> isRight) async* {
        yield ChallengesLoaded(isRight);
      }
    );
  }

  Stream<GamificationChallengesState> _getOwnerChallenges(GetOwnerChallenges event) async* {
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

  Stream<GamificationChallengesState> _createChallenge(CreateChallenge event) async* {
    var result = await _iChallengeRepository.createChallengeOwner(event.ownerId, event.challenge);
    yield* result.fold(
      (ChallengeFailure isLeft) async* {
        yield FailuredCreateChallenge(isLeft);
      }, 
      (Challenge isRight) async* {
        yield SuccessfulCreateChallenge(isRight);
      }
    );
  }

  Stream<GamificationChallengesState> _getAppEvents(GetAppEvents event) async* {
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

  Stream<GamificationChallengesState> _updateChallenge(UpdateChallenge event) async* {
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

  Stream<GamificationChallengesState> _updateActivities(UpdateChallengeActivities event) async* {
    for (var i = 0; i < event.challengeActivities.length; i++) {
      await _iChallengeRepository.updateStatusChallengeActivityOwner(event.ownerId, event.challengeId, event.challengeActivities[i]);
    }

    yield SuccessfulUpdateChallengeActivities(event.challengeId);
  }

  Stream<GamificationChallengesState> _updatePetPoints(UpdatePetPoints event) async* {
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
}