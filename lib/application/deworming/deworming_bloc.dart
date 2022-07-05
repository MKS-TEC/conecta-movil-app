



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/deworming/deworming_event.dart';
import 'package:conecta/application/deworming/deworming_state.dart';
import 'package:conecta/domain/core/entities/deworming.dart';
import 'package:conecta/domain/deworming/deworming_failure.dart';
import 'package:conecta/infrastructure/deworming/repositories/deworming_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';

@injectable
class DewormingBloc extends Bloc<DewormingEvent, DewormingState> {
  final DewormingRepository _dewormingRepository;
  final PeetRepository _petRepository;

  DewormingBloc(this._dewormingRepository, this._petRepository) : super(Initial());

  @override
  Stream<DewormingState> mapEventToState(DewormingEvent event) async* {
    if (event is GetDeworming) {
      yield* _getDewormings(event);
    } else if (event is CreateDeworming) {
      yield CreateDewormingProcessing();
      yield* _createDeworming(event);
    } else if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    }
  }

  Stream<DewormingState> _getDewormings(GetDeworming event) async* {
    var result = await _dewormingRepository.getDewormings(event.petId);
    yield* result.fold(
      (DewormingFailure isLeft) async* {
        yield DewormingNotWereLoaded();
      }, 
      (List<Deworming> isRight) async* {
        yield DewormingLoaded(isRight);
      }
    );
  }

  Stream<DewormingState> _createDeworming(CreateDeworming event) async* {
    var result = await _dewormingRepository.createDeworming(event.petId, event.deworming);
    yield* result.fold(
      (DewormingFailure isLeft) async* {
        yield FailuredCreateDeworming(isLeft);
      }, 
      (Deworming isRight) async* {
        yield SuccessfulCreateDeworming(isRight);
      }
    );
  }
}