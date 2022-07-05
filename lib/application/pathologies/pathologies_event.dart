import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/pathology.dart';

abstract class PathologiesEvent extends Equatable { }

class GetPathologies extends PathologiesEvent {
  final String petId;

  GetPathologies(this.petId);

  @override
  List<Object> get props => [];
}

class CreatePathology extends PathologiesEvent {
  final String petId;
  final Pathology pathology;

  CreatePathology(this.petId, this.pathology);

  @override
  List<Object> get props => []; 
}

class GetPetDefault extends PathologiesEvent {
  @override
  List<Object> get props => [];
}
