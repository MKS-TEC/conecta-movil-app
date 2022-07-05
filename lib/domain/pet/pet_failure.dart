import 'package:equatable/equatable.dart';

abstract class PetFailure extends Equatable { }

class ServerError extends PetFailure {
  @override
  List<Object> get props => [];
}