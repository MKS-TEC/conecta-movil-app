import 'package:equatable/equatable.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/pet/breed_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';

abstract class PetProfileState extends Equatable { }

class Initial extends PetProfileState {
  @override
  List<Object> get props => [];
}

class PetLoaded extends PetProfileState {
  final Pet pet;

  PetLoaded(this.pet);

  @override
  List<Object> get props => [pet];
}

class PetNotLoaded extends PetProfileState {
  @override
  List<Object> get props => [];
}

class UpdatePetProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdatePet extends PetProfileState {
  final PetFailure petFailure;

  FailuredUpdatePet(this.petFailure);

  @override
  List<Object> get props => [ petFailure ];
}

class SuccessfulUpdatePet extends PetProfileState {
  final Pet pet;

  SuccessfulUpdatePet(this.pet);

  @override
  List<Object> get props => [pet];
}

class GetBreedsProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}
 
class BreedsLoaded extends PetProfileState {
  final List<Breed> breeds;

  BreedsLoaded(this.breeds);

  @override
  List<Object> get props => [breeds];
}

class BreedsNotWereLoaded extends PetProfileState {
   final BreedFailure breedFailure;

  BreedsNotWereLoaded(this.breedFailure);

  @override
  List<Object> get props => [];
}

class GetChallengesOwnerProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}

class ChallengesOwnerLoaded extends PetProfileState {
  final List<Challenge> challenges;

  ChallengesOwnerLoaded(this.challenges);

  @override
  List<Object> get props => [challenges];
}

class ChallengesOwnerNotWereLoaded extends PetProfileState {
  final ChallengeFailure challengeFailure;

  ChallengesOwnerNotWereLoaded(this.challengeFailure);

  @override
  List<Object> get props => [];
}

class UpdateChallengeProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallenge extends PetProfileState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallenge(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallenge extends PetProfileState {
  @override
  List<Object> get props => [];
}

class UpdateChallengeActivityProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallengeActivity extends PetProfileState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallengeActivity(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallengeActivity extends PetProfileState {
  final ChallengeActivity challenge;

  SuccessfulUpdateChallengeActivity(this.challenge);

  @override
  List<Object> get props => [challenge];
}

class UpdatePetPointsProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdatePetPoints extends PetProfileState {
  final PetPointFailure petPointFailure;

  FailuredUpdatePetPoints(this.petPointFailure);

  @override
  List<Object> get props => [ petPointFailure ];
}

class SuccessfulUpdatePetPoints extends PetProfileState {
  @override
  List<Object> get props => [];
}

class GetAppEventsProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}

class AppEventsLoaded extends PetProfileState {
  final List<AppEvent> appEvents;

  AppEventsLoaded(this.appEvents);

  @override
  List<Object> get props => [appEvents];
}

class AppEventsNotWereLoaded extends PetProfileState {
  final AppEventFailure appEventFailure;

  AppEventsNotWereLoaded(this.appEventFailure);

  @override
  List<Object> get props => [];
}

class CreateAppEventProcessing extends PetProfileState {
  @override
  List<Object> get props => [];
}

class FailuredCreateAppEvent extends PetProfileState {
  @override
  List<Object> get props => [];
}
 

class SuccessfulCreateAppEvent extends PetProfileState {
  final AppEvent appEvent;

  SuccessfulCreateAppEvent(this.appEvent);

  @override
  List<Object> get props => [appEvent];
}
