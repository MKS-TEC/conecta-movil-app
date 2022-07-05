import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/pet_calendar/pet_calendar_event.dart';
import 'package:conecta/application/pet_calendar/pet_calendar_state.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/core/pet_calendar/pet_calendar.dart';
import 'package:conecta/domain/pet_calendar/pet_calendar_failure.dart';
import 'package:conecta/infrastructure/pet_calendar/repositories/pet_calendar_repository.dart';

@injectable
class PetCalendarBloc extends Bloc<PetCalendarEvent, PetCalendarState> {
  final PetCalendarRepository _pet_calendarRepository;

  PetCalendarBloc(this._pet_calendarRepository) : super(Initial());

  @override
  Stream<PetCalendarState> mapEventToState(PetCalendarEvent event) async* {
    if (event is GetPetCalendar) {
      yield GetPetCalendarProcessing();
      yield* _getPetCalendar(event);
    }
  }

  Stream<PetCalendarState> _getPetCalendar(GetPetCalendar event) async* {
    var result = await _pet_calendarRepository.getPetCalendar(event.uid);
    yield* result.fold(
      (PetCalendarFailure isLeft) async* {
        yield PetCalendarNotWasLoaded(isLeft);
      }, 
      (List<PetCalendarItem> isRight) async* {
        yield PetCalendarLoaded(isRight);
      }
    );
  }

}