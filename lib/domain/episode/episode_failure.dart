import 'package:equatable/equatable.dart';

abstract class EpisodeFailure extends Equatable { }

class ServerError extends EpisodeFailure {
  @override
  List<Object> get props => [];
}

