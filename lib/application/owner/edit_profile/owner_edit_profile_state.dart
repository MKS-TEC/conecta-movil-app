import 'package:equatable/equatable.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/country.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';

abstract class OwnerEditProfileState extends Equatable { }

class Initial extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class OwnerLoaded extends OwnerEditProfileState {
  final Owner owner;

  OwnerLoaded(this.owner);

  @override
  List<Object> get props => [owner];
}

class OwnerNotLoaded extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class CountriesNotLoaded extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class CountriesLoaded extends OwnerEditProfileState {
  final List<Country> countries;

  CountriesLoaded(this.countries);

  @override
  List<Object> get props => [countries];
}

class UpdateOwnerProcessing extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class FailuredUpdateOwner extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}
 

class SuccessfulUpdateOwner extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class GetChallengesOwnerProcessing extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class ChallengesOwnerLoaded extends OwnerEditProfileState {
  final List<Challenge> challenges;

  ChallengesOwnerLoaded(this.challenges);

  @override
  List<Object> get props => [challenges];
}

class ChallengesOwnerNotWereLoaded extends OwnerEditProfileState {
  final ChallengeFailure challengeFailure;

  ChallengesOwnerNotWereLoaded(this.challengeFailure);

  @override
  List<Object> get props => [];
}

class UpdateChallengeProcessing extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallenge extends OwnerEditProfileState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallenge(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallenge extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class UpdateChallengeActivityProcessing extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallengeActivity extends OwnerEditProfileState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallengeActivity(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallengeActivity extends OwnerEditProfileState {
  final ChallengeActivity challenge;

  SuccessfulUpdateChallengeActivity(this.challenge);

  @override
  List<Object> get props => [challenge];
}

class UpdatePetPointsProcessing extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdatePetPoints extends OwnerEditProfileState {
  final PetPointFailure petPointFailure;

  FailuredUpdatePetPoints(this.petPointFailure);

  @override
  List<Object> get props => [ petPointFailure ];
}

class SuccessfulUpdatePetPoints extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class GetAppEventsProcessing extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class AppEventsLoaded extends OwnerEditProfileState {
  final List<AppEvent> appEvents;

  AppEventsLoaded(this.appEvents);

  @override
  List<Object> get props => [appEvents];
}

class AppEventsNotWereLoaded extends OwnerEditProfileState {
  final AppEventFailure appEventFailure;

  AppEventsNotWereLoaded(this.appEventFailure);

  @override
  List<Object> get props => [];
}

class CreateAppEventProcessing extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}

class FailuredCreateAppEvent extends OwnerEditProfileState {
  @override
  List<Object> get props => [];
}
 

class SuccessfulCreateAppEvent extends OwnerEditProfileState {
  final AppEvent appEvent;

  SuccessfulCreateAppEvent(this.appEvent);

  @override
  List<Object> get props => [appEvent];
}
 