import 'package:equatable/equatable.dart';

abstract class NotificationFailure extends Equatable { }

class ServerError extends NotificationFailure {
  @override
  List<Object> get props => [];
}

