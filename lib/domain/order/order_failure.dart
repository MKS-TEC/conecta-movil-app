import 'package:equatable/equatable.dart';

abstract class OrdersFailure extends Equatable { }

class ServerError extends OrdersFailure {
  @override
  List<Object> get props => [];
}

