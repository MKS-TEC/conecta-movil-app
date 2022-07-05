import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/notification/notification_failure.dart';

abstract class NotificationsState extends Equatable { }

class Initial extends NotificationsState {
  @override
  List<Object> get props => [];
}

class GetNotificationsProcessing extends NotificationsState {
  @override
  List<Object> get props => [];
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationsNotWereLoaded extends NotificationsState {
  final NotificationFailure notificationFailure;

  NotificationsNotWereLoaded(this.notificationFailure);

  @override
  List<Object> get props => [];
}