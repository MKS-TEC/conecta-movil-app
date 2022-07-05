import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable { }

class GetServices extends ServicesEvent {
  @override
  List<Object> get props => []; 
}

class GetVideoConsultingService extends ServicesEvent {
  @override
  List<Object> get props => []; 
}