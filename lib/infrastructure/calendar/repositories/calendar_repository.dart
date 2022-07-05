import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';

@lazySingleton
class CalendarRepository {

  final FirebaseFirestore _firestore;

  CalendarRepository(this._firestore);

  Future<Either<CalendarFailure, List<CalendarEvent>>> getCalendars(String petId) async {
    try {
      var snapshot =
        await _firestore.collection("Mascotas").doc(petId).collection("Calendar").get();

      List<CalendarEvent> _calendars = List<CalendarEvent>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var calendar = CalendarEvent.fromMap(snapshot.data());
        _calendars.add(calendar);
      }
      
      return Right(_calendars);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<CalendarFailure, List<CalendarEvent>>> getCalendarsByProgram(String petId, String programId) async {
    try {
      var snapshot =
        await _firestore.collection("Mascotas").doc(petId).collection("Calendar").where('sourceId', isEqualTo: programId).get();

      List<CalendarEvent> _calendars = List<CalendarEvent>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var calendar = CalendarEvent.fromMap(snapshot.data());
        _calendars.add(calendar);
      }
      
      return Right(_calendars);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<CalendarFailure, CalendarEvent>> getCalendar(String petId, String calendarEventId) async {
    try {
      var snapshot =
        await _firestore.collection("Mascotas").doc(petId).collection("Calendar").doc(calendarEventId).get();

      CalendarEvent _calendar = CalendarEvent();

      if (!snapshot.exists) return Right(_calendar);
      
      _calendar = CalendarEvent.fromMap(snapshot.data()!);

      return Right(_calendar);
    } on Exception {
      return left(ServerError());
    }
  }

  /*Future<Either<CalendarFailure, CalendarEvent>> createCalendar(String petId, CalendarEvent calendar) async {
    try {
      String calendarEventId =
          _firestore.collection("Mascotas").doc(petId).collection("Calendar").doc().id.toString();

      calendar.calendarEventId = calendarEventId;

      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Calendar")
        .doc(calendar.calendarEventId)
        .set(calendar.toMap());

      return Right(calendar);
    } on Exception {
      return left(ServerError());
    }
  }*/

  Future<Either<CalendarFailure, Unit>> createCalendar(String petId, List<CalendarEvent> calendarEvents) async {
    try {
      WriteBatch writeBatch = _firestore.batch();

      calendarEvents.forEach((calendarEvent) {
        DocumentReference calendarEventDocumentReference =
          _firestore.collection("Mascotas").doc(petId).collection("Calendar").doc();

          calendarEvent.calendarEventId = calendarEventDocumentReference.id.toString();
          writeBatch.set(calendarEventDocumentReference, calendarEvent.toMap());
      });

      await writeBatch.commit();

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }
}