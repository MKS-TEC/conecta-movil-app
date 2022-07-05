import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/temperature.dart';
import 'package:conecta/domain/temperature/temperature_failure.dart';

abstract class TemperaturesState extends Equatable { }

class Initial extends TemperaturesState {
  @override
  List<Object> get props => [];
}

class TemperaturesLoaded extends TemperaturesState {
  final List<Temperature> temperatures;

  TemperaturesLoaded(this.temperatures);

  @override
  List<Object> get props => [temperatures];
}

class TemperaturesNotWereLoaded extends TemperaturesState {
  @override
  List<Object> get props => [];
}

class CreateTemperatureProcessing extends TemperaturesState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateTemperature extends TemperaturesState {
  final TemperatureFailure temperatureFailure;

  FailuredCreateTemperature(this.temperatureFailure);

  @override
  List<Object> get props => [ temperatureFailure ];
}

class SuccessfulCreateTemperature extends TemperaturesState {
  final Temperature temperature;

  SuccessfulCreateTemperature(this.temperature);

  @override
  List<Object> get props => [temperature];
}

class PetDefaultLoaded extends TemperaturesState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

