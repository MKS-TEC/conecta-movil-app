import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable { }

class GetNotifications extends NotificationsEvent {

  final String uid;
  GetNotifications(this.uid);

  @override
  List<Object> get props => []; 
}