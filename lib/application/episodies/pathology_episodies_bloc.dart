import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/episodies/pathology_episodes_event.dart';
import 'package:conecta/application/episodies/pathology_episodies_state.dart';
import 'package:conecta/domain/core/entities/episode.dart';
import 'package:conecta/domain/episode/episode_failure.dart';
import 'package:conecta/infrastructure/episodies/repositories/episodies_repository.dart';

@injectable
class PathologyEpisodiesBloc extends Bloc<PathologyEpisodiesEvent, PathologyEpisodiesState> {
  final EpisodiesRepository _episodiesRepository;

  PathologyEpisodiesBloc(this._episodiesRepository) : super(Initial());

  @override
  Stream<PathologyEpisodiesState> mapEventToState(PathologyEpisodiesEvent event) async* {
    if (event is GetEpisodies) {
      yield* _getEpisodies(event);
    }
  }

  Stream<PathologyEpisodiesState> _getEpisodies(GetEpisodies event) async* {
    var result = await _episodiesRepository.getEpisodies(event.petId, event.pathologyName);
    yield* result.fold(
      (EpisodeFailure isLeft) async* {
        yield EpisodiesNotWereLoaded();
      }, 
      (List<Episode> isRight) async* {
        yield EpisodiesLoaded(isRight);
      }
    );
  }
}