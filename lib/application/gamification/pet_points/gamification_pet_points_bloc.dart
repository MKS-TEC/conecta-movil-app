import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_event.dart';
import 'package:conecta/application/gamification/pet_points/gamification_pet_points_state.dart';
import 'package:conecta/domain/core/entities/pet_points.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/infrastructure/pet_points/repositories/pet_points_repository.dart';

@injectable
class GamificationPetPointsBloc extends Bloc<GamificationPetPointsEvent, GamificationPetPointsState> {
  final IPetPointRepository _iPetPointRepository;

  GamificationPetPointsBloc(this._iPetPointRepository) : super(Initial());

  @override
  Stream<GamificationPetPointsState> mapEventToState(GamificationPetPointsEvent event) async* {
    if (event is GetPetPoints) {
      yield GetPetPointsProcessing();
      yield* _getPetPoints(event);
    }
  }

  Stream<GamificationPetPointsState> _getPetPoints(GetPetPoints event) async* {
    var result = await _iPetPointRepository.getPetPoints(event.ownerId);
    yield* result.fold(
      (PetPointFailure isLeft) async* {
        yield PetPointsNotWereLoaded(isLeft);
      }, 
      (PetPoint isRight) async* {
        yield PetPointLoaded(isRight);
      }
    );
  }
}