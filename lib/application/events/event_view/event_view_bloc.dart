import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/events/event_view/event_view_event.dart';
import 'package:conecta/application/events/event_view/event_view_state.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/event/event_failure.dart';
import 'package:conecta/infrastructure/events/repositories/event_repository.dart';

@injectable
class EventViewBloc extends Bloc<EventViewEvent, EventViewState> {
  final IEventRepository _iEventRepository;

  EventViewBloc(this._iEventRepository) : super(Initial());

  @override
  Stream<EventViewState> mapEventToState(EventViewEvent event) async* {
    if (event is GetEvent) {
      yield GetEventProcessing();
      yield* _getEvent(event);
    }
  }

  Stream<EventViewState> _getEvent(GetEvent event) async* {
    var result = await _iEventRepository.getEventById(event.eventId);
    yield* result.fold(
      (EventFailure isLeft) async* {
        yield EventNotWereLoaded(isLeft);
      }, 
      (Event isRight) async* {
        yield EventLoaded(isRight);
      }
    );
  }
}