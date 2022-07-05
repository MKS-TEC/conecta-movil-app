import 'package:equatable/equatable.dart';

abstract class PetCalendarFailure extends Equatable { }

class ServerError extends PetCalendarFailure {
  @override
  List<Object> get props => [];
}

