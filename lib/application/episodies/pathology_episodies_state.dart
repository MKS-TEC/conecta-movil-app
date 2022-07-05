import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/episode.dart';

abstract class PathologyEpisodiesState extends Equatable { }

class Initial extends PathologyEpisodiesState {
  @override
  List<Object> get props => [];
}

class GetEpisodiesProcessing extends PathologyEpisodiesState {
  @override
  List<Object> get props => [];
}

class EpisodiesLoaded extends PathologyEpisodiesState {
  final List<Episode> episodes;

  EpisodiesLoaded(this.episodes);

  @override
  List<Object> get props => [episodes];
}

class EpisodiesNotWereLoaded extends PathologyEpisodiesState {
  @override
  List<Object> get props => [];
}
