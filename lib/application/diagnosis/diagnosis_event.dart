import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/diagnose.dart';

abstract class DiagnosisEvent extends Equatable { }

class GetDiagnosis extends DiagnosisEvent {
  final String petId;

  GetDiagnosis(this.petId);

  @override
  List<Object> get props => [];
}

class CreateDiagnose extends DiagnosisEvent {
  final String petId;
  final Diagnose diagnose;

  CreateDiagnose(this.petId, this.diagnose);

  @override
  List<Object> get props => []; 
}

class GetPetDefault extends DiagnosisEvent {
  @override
  List<Object> get props => [];
}