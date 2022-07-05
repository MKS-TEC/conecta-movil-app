import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/services/service.dart';
import 'package:conecta/domain/services/service_failure.dart';

abstract class ServicesState extends Equatable { }

class Initial extends ServicesState {
  @override
  List<Object> get props => [];
}

class GetServicesProcessing extends ServicesState {
  @override
  List<Object> get props => [];
}

class GetVideoConsultingServiceProcessing extends ServicesState {
  @override
  List<Object> get props => [];
}

class ServicesLoaded extends ServicesState {
  final List<Service> services;

  ServicesLoaded(this.services);

  @override
  List<Object> get props => [services];
}

class VideoConsultingServiceLoaded extends ServicesState {
  final Service service;

  VideoConsultingServiceLoaded(this.service);

  @override
  List<Object> get props => [service];
}

class ServicesNotWasLoaded extends ServicesState {
  final ServiceFailure service_failure;

  ServicesNotWasLoaded(this.service_failure);

  @override
  List<Object> get props => [];
}

class VideoConsultingServiceNotWasLoaded extends ServicesState {
  final ServiceFailure service_failure;

  VideoConsultingServiceNotWasLoaded(this.service_failure);

  @override
  List<Object> get props => [];
}