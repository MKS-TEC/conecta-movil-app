
import 'package:equatable/equatable.dart';

abstract class ProgramViewEvent extends Equatable { }

class GetProgram extends ProgramViewEvent {
  final String petId;
  final String programId;

  GetProgram(this.petId, this.programId);

  @override
  List<Object> get props => [];
}

class GetPetDefault extends ProgramViewEvent {
  @override
  List<Object> get props => [];
}

class GetCalendars extends ProgramViewEvent {
  final String petId;

  GetCalendars(this.petId);

  @override
  List<Object> get props => []; 
}
