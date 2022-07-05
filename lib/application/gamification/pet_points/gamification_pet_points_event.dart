import 'package:equatable/equatable.dart';

abstract class GamificationPetPointsEvent extends Equatable { }

class GetPetPoints extends GamificationPetPointsEvent {
  final String ownerId;

  GetPetPoints(this.ownerId);

  @override
  List<Object> get props => [ownerId]; 
}