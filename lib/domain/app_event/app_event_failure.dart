import 'package:equatable/equatable.dart';

abstract class AppEventFailure extends Equatable { }

class ServerError extends AppEventFailure {
  @override
  List<Object> get props => [];
}

