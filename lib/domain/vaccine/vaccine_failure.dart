import 'package:equatable/equatable.dart';

abstract class VaccineFailure extends Equatable { }

class ServerError extends VaccineFailure {
  @override
  List<Object> get props => [];
}

