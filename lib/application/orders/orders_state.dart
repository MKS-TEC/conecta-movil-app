import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/order/order_failure.dart';

abstract class OrdersState extends Equatable { }

class Initial extends OrdersState {
  @override
  List<Object> get props => [];
}

class GetOrdersProcessing extends OrdersState {
  @override
  List<Object> get props => [];
}

class SuccessfulSetOrder extends OrdersState {
  @override
  List<Object> get props => [];
}

class SuccessfulUpdateOrderConsultation extends OrdersState {
  @override
  List<Object> get props => [];
}

class FailuredSetOrder extends OrdersState {
  final OrdersFailure orderFailure;

  FailuredSetOrder(this.orderFailure);

  @override
  List<Object> get props => [ orderFailure ];
}

class SetCreationOrderProcessing extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersState {
  final List<NotificationModel> notifications;

  OrdersLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class OrdersNotWereLoaded extends OrdersState {
  final OrdersFailure orderFailure;

  OrdersNotWereLoaded(this.orderFailure);

  @override
  List<Object> get props => [];
}