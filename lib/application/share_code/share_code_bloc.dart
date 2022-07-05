import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/share_code/share_code_event.dart';
import 'package:conecta/application/share_code/share_code_state.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/domain/share_code/share_code_failure.dart';
import 'package:conecta/infrastructure/app_events/repositories/app_event_repositories.dart';
import 'package:conecta/infrastructure/challenges/repositories/challenges_repositories.dart';
import 'package:conecta/infrastructure/pet_points/repositories/pet_points_repository.dart';
import 'package:conecta/infrastructure/share_code/repositories/share_code_repositories.dart';

@injectable
class ShareCodeBloc extends Bloc<ShareCodeEvent, ShareCodeState> {
  final ShareCodeRepository _shareCodeRepository;
  final IChallengeRepository _iChallengeRepository;
  final IPetPointRepository _iPetPointRepository;
  final IAppEventRepository _iAppEventRepository;
  
  ShareCodeBloc(
    this._shareCodeRepository,
    this._iChallengeRepository,
    this._iPetPointRepository,
    this._iAppEventRepository
  ) : super(Initial());

  @override
  Stream<ShareCodeState> mapEventToState(ShareCodeEvent event) async* {
    if (event is ShareUserCode) {
      yield SharingCode();
      yield* _shareCode(event);
    }else if(event is RedeemUserCode){
      yield RedeemingUserCode();
      yield* _redeemUserCode(event);
    }else if(event is GetNumberOfGuests){
      yield GettingGuests();
      yield* _getNumberOfGuests(event);
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

  Stream<ShareCodeState> _shareCode(ShareUserCode event) async* {
    var result = await _shareCodeRepository.shareCode(event.owner);
    yield* result.fold(
      (ShareCodeFailure isLeft) async* {
        yield UserCodeNotShared();
      }, 
      (Unit isRight) async* {
        yield UserCodeShared();
      }
    );
  }

  Stream<ShareCodeState> _redeemUserCode(RedeemUserCode event) async* {
    var result = await _shareCodeRepository.redeemUserCode(event.code);
    yield* result.fold(
      (ShareCodeFailure isLeft) async* {
        yield UserCodeNotRedeemed();
      }, 
      (Unit isRight) async* {
        yield UserCodeRedeemed();
      }
    );
  }

  Stream<ShareCodeState> _getNumberOfGuests(GetNumberOfGuests event) async* {
    var result = await _shareCodeRepository.getNumberOfGuests(event.ownerId);
    yield* result.fold(
      (ShareCodeFailure isLeft) async* {
        yield GuestsNotLoaded(isLeft);
      }, 
      (int isRight) async* {
        yield GuestsLoaded(isRight);
      }
    );
  }
  
  Stream<ShareCodeState> _getOwnerChallenges(GetOwnerChallenges event) async* {
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

  Stream<ShareCodeState> _updateChallenge(UpdateChallenge event) async* {
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

  Stream<ShareCodeState> _updateChallengeActivity(UpdateChallengeActivity event) async* {
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

  Stream<ShareCodeState> _updatePetPoints(UpdatePetPoints event) async* {
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

  Stream<ShareCodeState> _createAppEvent(CreateAppEvent event) async* {
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

  Stream<ShareCodeState> _getAppEvents(GetAppEvents event) async* {
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