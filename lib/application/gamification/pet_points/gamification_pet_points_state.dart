import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/pet_points.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';

abstract class GamificationPetPointsState extends Equatable { }

class Initial extends GamificationPetPointsState {
  @override
  List<Object> get props => [];
}

class GetPetPointsProcessing extends GamificationPetPointsState {
  @override
  List<Object> get props => [];
}

class PetPointLoaded extends GamificationPetPointsState {
  final PetPoint petPoints;

  PetPointLoaded(this.petPoints);

  @override
  List<Object> get props => [petPoints];
}

class PetPointsNotWereLoaded extends GamificationPetPointsState {
  final PetPointFailure petPointFailure;

  PetPointsNotWereLoaded(this.petPointFailure);

  @override
  List<Object> get props => [];
}