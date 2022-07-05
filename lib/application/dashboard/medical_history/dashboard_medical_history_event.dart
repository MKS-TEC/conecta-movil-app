
import 'package:equatable/equatable.dart';

abstract class DashboardMedicalHistoryEvent extends Equatable { }

class GetPetDefault extends DashboardMedicalHistoryEvent {
  @override
  List<Object> get props => [];
}

class GetPet extends DashboardMedicalHistoryEvent {
  final String petId;

  GetPet(this.petId);

  @override
  List<Object> get props => [];
}

class GetWeights extends DashboardMedicalHistoryEvent {
  final String petId;

  GetWeights(this.petId);

  @override
  List<Object> get props => [];
}
