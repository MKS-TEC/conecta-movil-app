import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/orders/orders_event.dart';
import 'package:conecta/application/orders/orders_state.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/order/order_failure.dart';
import 'package:conecta/infrastructure/orders/repositories/orders_repository.dart';

@injectable
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _ordersRepository;

  OrdersBloc(this._ordersRepository) : super(Initial());

  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async* {
    if (event is GetOrders) {
      yield GetOrdersProcessing();
      yield* _getOrders(event);
    } else if (event is SetOrderConsultation) {
      yield* _setOrder(event);
    } else if(event is UpdateConsultationOrder) {
      yield* _updateConsultationOrder(event);
    }
  }

  Stream<OrdersState> _getOrders(GetOrders event) async* {
    var result = await _ordersRepository.getOrders(event.uid);
    yield* result.fold(
      (OrdersFailure isLeft) async* {
        yield OrdersNotWereLoaded(isLeft);
      }, 
      (List<NotificationModel> isRight) async* {
        yield OrdersLoaded(isRight);
      }
    );
  }

  Stream<OrdersState> _setOrder(SetOrderConsultation event) async* {
    var result = await _ordersRepository.setOrderConsultation(event.uid, event.dateSelected, event.hourSelected, event.service, event.points);
    yield* result.fold(
      (OrdersFailure isLeft) async* {
        yield FailuredSetOrder(isLeft);
      }, 
      (Unit isRight) async* {
        yield SuccessfulSetOrder();
      }
    );
  }
  
  Stream<OrdersState> _updateConsultationOrder(UpdateConsultationOrder event) async* {
    var result = await _ordersRepository.updateOrderConsultation(event.calendarEvent);
    yield* result.fold(
      (OrdersFailure isLeft) async* {
        yield FailuredSetOrder(isLeft);
      }, 
      (Unit isRight) async* {
        yield SuccessfulUpdateOrderConsultation();
      }
    );
  }

}