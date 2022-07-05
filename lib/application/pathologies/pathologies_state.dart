import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/pathology.dart';
import 'package:conecta/domain/pathology/pathology_failure.dart';

abstract class PathologiesState extends Equatable { }

class Initial extends PathologiesState {
  @override
  List<Object> get props => [];
}

class PathologiesLoaded extends PathologiesState {
  final List<Pathology> pathologies;

  PathologiesLoaded(this.pathologies);

  @override
  List<Object> get props => [pathologies];
}

class PathologiesNotWereLoaded extends PathologiesState {
  @override
  List<Object> get props => [];
}

class CreatePathologyProcessing extends PathologiesState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreatePathology extends PathologiesState {
  final PathologyFailure pathologyFailure;

  FailuredCreatePathology(this.pathologyFailure);

  @override
  List<Object> get props => [ pathologyFailure ];
}

class SuccessfulCreatePathology extends PathologiesState {
  final Pathology pathology;

  SuccessfulCreatePathology(this.pathology);

  @override
  List<Object> get props => [pathology];
}

class PetDefaultLoaded extends PathologiesState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}
