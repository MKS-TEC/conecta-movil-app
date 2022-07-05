import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/event/event_failure.dart';

@lazySingleton
class IEventRepository {

  final FirebaseFirestore _firestore;

  IEventRepository(this._firestore);

  Future<Either<EventFailure, List<Event>>> getEvents() {
    Future<Either<EventFailure, List<Event>>> _result = MockEventRepository(_firestore).getEvents();

    return _result;
  }

  Future<Either<EventFailure, Event>> getEventById(String eventId) {
    Future<Either<EventFailure, Event>> _result = MockEventRepository(_firestore).getEventById(eventId);

    return _result;
  }
}

class FirebaseEventRepository extends IEventRepository {
  FirebaseEventRepository(FirebaseFirestore firestore) : super(firestore);

  @override
  Future<Either<EventFailure, List<Event>>> getEvents() async {
    try {
      var snapshot =
        await _firestore.collection("Events").get();

      List<Event> _events = List<Event>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var event = Event.fromMap(snapshot.data());

        _events.add(event);
      }
      
      return Right(_events);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<EventFailure, Event>> getEventById(String eventId) async {
    try {
      var snapshot =
        await _firestore.collection("Events").doc(eventId).get();

      Event _event = Event();

      if (!snapshot.exists) return Right(_event);

      _event = Event.fromMap(snapshot.data()!);

      return Right(_event);
    } on Exception {
      return left(ServerError());
    }
  }
}

class MockEventRepository extends IEventRepository {
  MockEventRepository(FirebaseFirestore firestore) : super(firestore);

  @override
  Future<Either<EventFailure, List<Event>>> getEvents() async {
    try {
      final String response = await rootBundle.loadString('assets/json/events.json');
      final eventsData = await json.decode(response);

      List<Event> _events = List<Event>.empty(growable: true);

      for (Map<String, dynamic> eventData in eventsData) {
        var event = Event.fromMap(eventData);

        _events.add(event);
      }
      
      return Right(_events);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<EventFailure, Event>> getEventById(String eventId) async {
    try {
      final String response = await rootBundle.loadString('assets/json/events.json');
      final eventsData = await json.decode(response);

      Event _event = Event();

      for (Map<String, dynamic> eventData in eventsData) {
        var event = Event.fromMap(eventData);

        if (event.eventId == eventId) {
          _event = event;
        }
      }
      
      return Right(_event);
    } on Exception {
      return left(ServerError());
    }
  }
}
