

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/temperatures/temperatures_event.dart';
import 'package:conecta/application/temperatures/temperatures_state.dart';
import 'package:conecta/domain/core/entities/temperature.dart';
import 'package:conecta/domain/temperature/temperature_failure.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/temperature/repositories/temperature_repositories.dart';


@injectable
class TemperaturesBloc extends Bloc<TemperaturesEvent, TemperaturesState> {
  final TemperatureRepository _temperaturesRepository;
  final PeetRepository _petRepository;

  TemperaturesBloc(this._temperaturesRepository, this._petRepository) : super(Initial());

  @override
  Stream<TemperaturesState> mapEventToState(TemperaturesEvent event) async* {
    if (event is GetTemperatures) {
      yield* _getTemperatures(event);
    } else if (event is CreateTemperature) {
      yield CreateTemperatureProcessing();
      yield* _createTemperature(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    }
  }

  Stream<TemperaturesState> _getTemperatures(GetTemperatures event) async* {
    var result = await _temperaturesRepository.getTemperatures(event.petId);
    yield* result.fold(
      (TemperatureFailure isLeft) async* {
        yield TemperaturesNotWereLoaded();
      }, 
      (List<Temperature> isRight) async* {
        yield TemperaturesLoaded(isRight);
      }
    );
  }

  Stream<TemperaturesState> _createTemperature(CreateTemperature event) async* {
    var result = await _temperaturesRepository.createTemperature(event.petId, event.temperature);
    yield* result.fold(
      (TemperatureFailure isLeft) async* {
        yield FailuredCreateTemperature(isLeft);
      }, 
      (Temperature isRight) async* {
        yield SuccessfulCreateTemperature(isRight);
      }
    );
  }
}