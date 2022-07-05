import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';

@lazySingleton
class IAppEventRepository {

  final FirebaseFirestore _firestore;

  IAppEventRepository(this._firestore);

  Future<Either<AppEventFailure, List<AppEvent>>> getAppEvents(String ownerId) {
    Future<Either<AppEventFailure, List<AppEvent>>> _result = FirebaseAppEventRepository(_firestore).getAppEvents(ownerId);

    return _result;
  }

  Future<Either<AppEventFailure, AppEvent>> createAppEvent(String ownerId, AppEvent appEvent) {
    Future<Either<AppEventFailure, AppEvent>> _result = FirebaseAppEventRepository(_firestore).createAppEvent(ownerId, appEvent);

    return _result;
  }
}

class FirebaseAppEventRepository extends IAppEventRepository {
  FirebaseAppEventRepository(FirebaseFirestore firestore) : super(firestore);

  @override
  Future<Either<AppEventFailure, List<AppEvent>>> getAppEvents(String ownerId) async {
    try {
      var snapshot =
        await _firestore.collection("Dueños").doc(ownerId).collection("AppEvents").get();

      List<AppEvent> _appEvents = List<AppEvent>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var appEvent = AppEvent.fromMap(snapshot.data());
        _appEvents.add(appEvent);
      }
      
      return Right(_appEvents);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<AppEventFailure, AppEvent>> createAppEvent(String ownerId, AppEvent appEvent) async {
    try {
      String appEventId =
        _firestore.collection("Mascotas").doc().id.toString();

      appEvent.appEventId = appEventId;

      await _firestore
        .collection('Dueños')
        .doc(ownerId)
        .collection("AppEvents")
        .doc(appEvent.appEventId)
        .set(appEvent.toMap());

      return Right(appEvent);
    } on Exception {
      return left(ServerError());
    }
  }
}

class MockAppEventRepository extends IAppEventRepository {
  MockAppEventRepository(FirebaseFirestore firestore) : super(firestore);
}
