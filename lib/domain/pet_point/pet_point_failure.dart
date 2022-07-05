import 'package:equatable/equatable.dart';

abstract class PetPointFailure extends Equatable { }

class ServerError extends PetPointFailure {
  @override
  List<Object> get props => [];
}

