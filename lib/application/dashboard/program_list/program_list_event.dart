import 'package:equatable/equatable.dart';

abstract class ProgramListEvent extends Equatable { }

class GetPrograms extends ProgramListEvent {
  final String petId;

  GetPrograms(this.petId);

  @override
  List<Object> get props => []; 
}

class GetMainProgramsCategories extends ProgramListEvent {
  GetMainProgramsCategories();

  @override
  List<Object> get props => []; 
}

class GetCalendars extends ProgramListEvent {
  final String petId;

  GetCalendars(this.petId);

  @override
  List<Object> get props => []; 
}

class GetPetDefault extends ProgramListEvent {
  @override
  List<Object> get props => [];
}
