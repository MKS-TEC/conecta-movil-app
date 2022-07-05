import 'package:equatable/equatable.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';

abstract class GamificationChallengesState extends Equatable { }

class Initial extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}

class GetChallengesProcessing extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}

class ChallengesLoaded extends GamificationChallengesState {
  final List<Challenge> challenges;

  ChallengesLoaded(this.challenges);

  @override
  List<Object> get props => [challenges];
}

class ChallengesNotWereLoaded extends GamificationChallengesState {
  final ChallengeFailure challengeFailure;

  ChallengesNotWereLoaded(this.challengeFailure);

  @override
  List<Object> get props => [];
}

class GetChallengesOwnerProcessing extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}

class ChallengesOwnerLoaded extends GamificationChallengesState {
  final List<Challenge> challenges;

  ChallengesOwnerLoaded(this.challenges);

  @override
  List<Object> get props => [challenges];
}

class ChallengesOwnerNotWereLoaded extends GamificationChallengesState {
  final ChallengeFailure challengeFailure;

  ChallengesOwnerNotWereLoaded(this.challengeFailure);

  @override
  List<Object> get props => [];
}

class CreateChallengeProcessing extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateChallenge extends GamificationChallengesState {
  final ChallengeFailure challengeFailure;

  FailuredCreateChallenge(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulCreateChallenge extends GamificationChallengesState {
  final Challenge challenge;

  SuccessfulCreateChallenge(this.challenge);

  @override
  List<Object> get props => [challenge];
}

class GetAppEventsProcessing extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}

class AppEventsLoaded extends GamificationChallengesState {
  final List<AppEvent> appEvents;

  AppEventsLoaded(this.appEvents);

  @override
  List<Object> get props => [appEvents];
}

class AppEventsNotWereLoaded extends GamificationChallengesState {
  final AppEventFailure appEventFailure;

  AppEventsNotWereLoaded(this.appEventFailure);

  @override
  List<Object> get props => [];
}

class UpdateChallengeProcessing extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallenge extends GamificationChallengesState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallenge(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallenge extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}

class UpdateChallengeActivitiesProcessing extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallengeActivities extends GamificationChallengesState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallengeActivities(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallengeActivities extends GamificationChallengesState {
  final String challengeId;

  SuccessfulUpdateChallengeActivities(this.challengeId);

  @override
  List<Object> get props => [challengeId];
}

class UpdatePetPointsProcessing extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdatePetPoints extends GamificationChallengesState {
  final PetPointFailure petPointFailure;

  FailuredUpdatePetPoints(this.petPointFailure);

  @override
  List<Object> get props => [ petPointFailure ];
}

class SuccessfulUpdatePetPoints extends GamificationChallengesState {
  @override
  List<Object> get props => [];
}
