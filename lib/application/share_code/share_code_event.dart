import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/owner.dart';

abstract class ShareCodeEvent extends Equatable { }

class ShareUserCode extends ShareCodeEvent {
  
  final Owner owner;
  ShareUserCode(this.owner);

  @override
  List<Object> get props => []; 
}

class RedeemUserCode extends ShareCodeEvent {
  
  final String code;
  RedeemUserCode(this.code);

  @override
  List<Object> get props => []; 
}


class GetNumberOfGuests extends ShareCodeEvent {
  final String ownerId;

  GetNumberOfGuests(this.ownerId);

  @override
  List<Object> get props => []; 
}

class GetOwnerChallenges extends ShareCodeEvent {
  final String ownerId;

  GetOwnerChallenges(this.ownerId);

  @override
  List<Object> get props => []; 
}

class GetAppEvents extends ShareCodeEvent {
  final String ownerId;

  GetAppEvents(this.ownerId);

  @override
  List<Object> get props => []; 
}

class UpdateChallenge extends ShareCodeEvent {
  final String ownerId;
  final String challengeId;

  UpdateChallenge(this.ownerId, this.challengeId);

  @override
  List<Object> get props => []; 
}

class CreateAppEvent extends ShareCodeEvent {
  final String ownerId;
  final AppEvent appEvent;

  CreateAppEvent(this.ownerId, this.appEvent);

  @override
  List<Object> get props => []; 
}

class UpdateChallengeActivity extends ShareCodeEvent {
  final String ownerId;
  final String challengeId;
  final ChallengeActivity challengeActivity;

  UpdateChallengeActivity(this.ownerId, this.challengeId, this.challengeActivity);

  @override
  List<Object> get props => []; 
}

class UpdatePetPoints extends ShareCodeEvent {
  final String ownerId;
  final int petPointsQuantity;

  UpdatePetPoints(this.ownerId, this.petPointsQuantity);

  @override
  List<Object> get props => []; 
}
