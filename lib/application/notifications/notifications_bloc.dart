import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/notifications/notifications_event.dart';
import 'package:conecta/application/notifications/notifications_state.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/notification/notification_failure.dart';
import 'package:conecta/infrastructure/notifications/repositories/notifications_repository.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationsRepository;

  NotificationsBloc(this._notificationsRepository) : super(Initial());

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is GetNotifications) {
      yield GetNotificationsProcessing();
      yield* _getNotifications(event);
    }
  }

  Stream<NotificationsState> _getNotifications(GetNotifications event) async* {
    var result = await _notificationsRepository.getNotifications(event.uid);
    yield* result.fold(
      (NotificationFailure isLeft) async* {
        yield NotificationsNotWereLoaded(isLeft);
      }, 
      (List<NotificationModel> isRight) async* {
        yield NotificationsLoaded(isRight);
      }
    );
  }

}