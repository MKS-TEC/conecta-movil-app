import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/diagnose.dart';
import 'package:conecta/domain/diagnosis/diagnosis_failure.dart';

abstract class DiagnosisState extends Equatable { }

class Initial extends DiagnosisState {
  @override
  List<Object> get props => [];
}

class DiagnosisLoaded extends DiagnosisState {
  final List<Diagnose> diagnosis;

  DiagnosisLoaded(this.diagnosis);

  @override
  List<Object> get props => [diagnosis];
}

class DiagnosisNotWereLoaded extends DiagnosisState {
  @override
  List<Object> get props => [];
}

class CreateDiagnoseProcessing extends DiagnosisState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateDiagnose extends DiagnosisState {
  final DiagnosisFailure diagnosisFailure;

  FailuredCreateDiagnose(this.diagnosisFailure);

  @override
  List<Object> get props => [ diagnosisFailure ];
}

class SuccessfulCreateDiagnose extends DiagnosisState {
  final Diagnose diagnose;

  SuccessfulCreateDiagnose(this.diagnose);

  @override
  List<Object> get props => [diagnose];
}

class PetDefaultLoaded extends DiagnosisState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}
