import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/notification/notification_failure.dart';

@lazySingleton
class NotificationRepository {

  final FirebaseFirestore _firestore;

  NotificationRepository(this._firestore);

  Future<Either<NotificationFailure, List<NotificationModel>>> getNotifications(String uid) async {
    try {
      var snapshot = await _firestore.collection("Dueños")
        .doc(uid).collection("Notifications").get();

      List<NotificationModel> _notifications = List<NotificationModel>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var notification = NotificationModel.fromMap(snapshot.data());
        _notifications.add(notification);
      }
      
      return Right(_notifications);
    } on Exception {
      return left(ServerError());
    }
  }
}