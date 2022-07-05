import 'package:equatable/equatable.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/domain/share_code/share_code_failure.dart';

abstract class ShareCodeState extends Equatable { }

class Initial extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class SharingCode extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class UserCodeShared extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class UserCodeNotShared extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class RedeemingUserCode extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class UserCodeRedeemed extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class UserCodeNotRedeemed extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class GettingGuests extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class GuestsNotLoaded extends ShareCodeState {
  final ShareCodeFailure shareCodeFailure;
  GuestsNotLoaded(this.shareCodeFailure);

  @override
  List<Object> get props => [];
}

class GuestsLoaded extends ShareCodeState {
  final int numberOfGuests;
  GuestsLoaded(this.numberOfGuests);

  @override
  List<Object> get props => [];
}

class LessThanFiveInvited extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class FiveInvited extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class MoreThanFiveInvited extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class GetChallengesOwnerProcessing extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class ChallengesOwnerLoaded extends ShareCodeState {
  final List<Challenge> challenges;

  ChallengesOwnerLoaded(this.challenges);

  @override
  List<Object> get props => [challenges];
}

class ChallengesOwnerNotWereLoaded extends ShareCodeState {
  final ChallengeFailure challengeFailure;

  ChallengesOwnerNotWereLoaded(this.challengeFailure);

  @override
  List<Object> get props => [];
}

class UpdateChallengeProcessing extends ShareCodeState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallenge extends ShareCodeState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallenge(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallenge extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class UpdateChallengeActivityProcessing extends ShareCodeState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallengeActivity extends ShareCodeState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallengeActivity(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallengeActivity extends ShareCodeState {
  final ChallengeActivity challenge;

  SuccessfulUpdateChallengeActivity(this.challenge);

  @override
  List<Object> get props => [challenge];
}

class UpdatePetPointsProcessing extends ShareCodeState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdatePetPoints extends ShareCodeState {
  final PetPointFailure petPointFailure;

  FailuredUpdatePetPoints(this.petPointFailure);

  @override
  List<Object> get props => [ petPointFailure ];
}

class SuccessfulUpdatePetPoints extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class GetAppEventsProcessing extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class AppEventsLoaded extends ShareCodeState {
  final List<AppEvent> appEvents;

  AppEventsLoaded(this.appEvents);

  @override
  List<Object> get props => [appEvents];
}

class AppEventsNotWereLoaded extends ShareCodeState {
  final AppEventFailure appEventFailure;

  AppEventsNotWereLoaded(this.appEventFailure);

  @override
  List<Object> get props => [];
}

class CreateAppEventProcessing extends ShareCodeState {
  @override
  List<Object> get props => [];
}

class FailuredCreateAppEvent extends ShareCodeState {
  @override
  List<Object> get props => [];
}
 

class SuccessfulCreateAppEvent extends ShareCodeState {
  final AppEvent appEvent;

  SuccessfulCreateAppEvent(this.appEvent);

  @override
  List<Object> get props => [appEvent];
}