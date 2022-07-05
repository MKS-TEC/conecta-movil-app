import 'package:equatable/equatable.dart';

abstract class ShareCodeFailure extends Equatable { }

class ServerError extends ShareCodeFailure {
  @override
  List<Object> get props => [];
}

