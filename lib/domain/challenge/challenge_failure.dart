import 'package:equatable/equatable.dart';

abstract class ChallengeFailure extends Equatable { }

class ServerError extends ChallengeFailure {
  @override
  List<Object> get props => [];
}

