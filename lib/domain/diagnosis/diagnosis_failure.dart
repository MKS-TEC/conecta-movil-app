import 'package:equatable/equatable.dart';

abstract class DiagnosisFailure extends Equatable { }

class ServerError extends DiagnosisFailure {
  @override
  List<Object> get props => [];
}

