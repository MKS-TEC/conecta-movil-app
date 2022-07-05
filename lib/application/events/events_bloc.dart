import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/events/events_event.dart';
import 'package:conecta/application/events/events_state.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/event/event_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/infrastructure/events/repositories/event_repository.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';

@injectable
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final PeetRepository _petRepository;
  final IEventRepository _iEventRepository;

  EventsBloc(this._petRepository, this._iEventRepository) : super(Initial());

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    if (event is GetPetDefault) {
      String? petId = _petRepository.getPetDefault();
      yield PetDefaultLoaded(petId);
    } else if (event is GetEvents) {
      yield GetEventsProcessing();
      yield* _getEvents(event);
    } if (event is GetPet) {
      yield* _getPet(event);
    }
  }

  Stream<EventsState> _getPet(GetPet event) async* {
    var result = await _petRepository.getSubjectPet(event.petId);
    yield* result.fold(
      (PetFailure isLeft) async* {
        yield PetNotLoaded();
      }, 
      (Pet isRight) async* {
        yield PetLoaded(isRight);
      }
    );
  }

  Stream<EventsState> _getEvents(GetEvents event) async* {
    var result = await _iEventRepository.getEvents();
    yield* result.fold(
      (EventFailure isLeft) async* {
        yield EventsNotWereLoaded(isLeft);
      }, 
      (List<Event> isRight) async* {
        yield EventsLoaded(isRight);
      }
    );
  }
}