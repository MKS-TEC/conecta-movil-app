import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/temperature.dart';

abstract class TemperaturesEvent extends Equatable { }

class GetTemperatures extends TemperaturesEvent {
  final String petId;

  GetTemperatures(this.petId);

  @override
  List<Object> get props => [];
}

class CreateTemperature extends TemperaturesEvent {
  final String petId;
  final Temperature temperature;

  CreateTemperature(this.petId, this.temperature);

  @override
  List<Object> get props => []; 
}

class GetPetDefault extends TemperaturesEvent {
  @override
  List<Object> get props => [];
}