import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class CalendarEvent {
  String? calendarEventId;
  String? petId;
  String? details;
  DateTime? start;
  DateTime? end;
  bool? isAllDay;
  bool? done;
  String? title;
  String? source;
  String? sourceId;
  DateTime? createdOn;

  CalendarEvent();

  Map<String, dynamic> toMap() => {
    "calendarEventId": calendarEventId,
    "petId": petId,
    "details": details,
    "start": start,
    "end": end,
    "isAllDay": isAllDay,
    "done": done,
    "title": title,
    "source": source,
    "sourceId": sourceId,
    "createdOn": FieldValue.serverTimestamp(),
  };

  CalendarEvent.fromMap(Map<String, dynamic> map) {
    try {
      this.calendarEventId = map["calendarEventId"] ?? "";
      this.petId = map["petId"] ?? "";
      this.details = map["details"] ?? "";
      this.title = map["title"] ?? "";
      this.source = map["source"] ?? "";
      this.sourceId = map["sourceId"] ?? "";
      this.isAllDay = map["isAllDay"] != null ? map["isAllDay"] : false;
      this.done = map["done"] != null ? map["done"] : false;
      this.start = map["start"] != null ? map["start"].toDate() : null;
      this.end = map["end"] != null ? map["end"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}
