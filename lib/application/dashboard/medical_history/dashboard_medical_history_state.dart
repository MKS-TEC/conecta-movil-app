import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/weight.dart';

abstract class DashboardMedicalHistoryState extends Equatable { }

class Initial extends DashboardMedicalHistoryState {
  @override
  List<Object> get props => [];
}

class PetDefaultLoaded extends DashboardMedicalHistoryState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

class PetLoaded extends DashboardMedicalHistoryState {
  final Pet pet;

  PetLoaded(this.pet);

  @override
  List<Object> get props => [];
}

class PetNotLoaded extends DashboardMedicalHistoryState {
  @override
  List<Object> get props => [];
}

class WeightsLoaded extends DashboardMedicalHistoryState {
  final List<Weight> weights;

  WeightsLoaded(this.weights);

  @override
  List<Object> get props => [weights];
}

class WeightsNotWereLoaded extends DashboardMedicalHistoryState {
  @override
  List<Object> get props => [];
}
