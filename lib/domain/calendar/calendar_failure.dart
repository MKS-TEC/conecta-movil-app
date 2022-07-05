import 'package:equatable/equatable.dart';

abstract class CalendarFailure extends Equatable { }

class ServerError extends CalendarFailure {
  @override
  List<Object> get props => [];
}

