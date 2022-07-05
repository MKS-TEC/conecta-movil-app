import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/services/day_agenda/day_agenda.dart';
import 'package:conecta/domain/core/services/service.dart';

abstract class OrdersEvent extends Equatable { }

class GetOrders extends OrdersEvent {

  final String uid;
  GetOrders(this.uid);

  @override
  List<Object> get props => []; 
}

class SetOrderConsultation extends OrdersEvent {

  final String uid;
  final DayInAgenda dateSelected;
  final String hourSelected;
  final Service service;
  final int points;
  SetOrderConsultation(this.uid, this.dateSelected, this.hourSelected, this.service, this.points);

  @override
  List<Object> get props => []; 
}

class UpdateConsultationOrder extends OrdersEvent {

  final CalendarEvent calendarEvent;
  UpdateConsultationOrder(this.calendarEvent);

  @override
  List<Object> get props => []; 
}