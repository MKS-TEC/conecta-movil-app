import 'package:equatable/equatable.dart';

abstract class PathologyEpisodiesEvent extends Equatable { }

class GetEpisodies extends PathologyEpisodiesEvent {
  final String petId;
  final String pathologyName;

  GetEpisodies(this.petId, this.pathologyName);

  @override
  List<Object> get props => [];
}
