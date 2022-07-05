import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class PetCalendarItem {
  String? calendarEventId;
  String? petId;
  String? details;
  String? title;
  Timestamp? start;
  Timestamp? end;
  String? source;
  String? sourceId;
  bool? done;
  bool? isAllDay;
  Timestamp? createdOn;

  PetCalendarItem();

  PetCalendarItem.fromMap(Map<String, dynamic> map) {
    try {
      this.calendarEventId = map["calendarEventId"] ?? "";
      this.petId = map["petId"] ?? "";
      this.details = map["details"] ?? "";
      this.title = map["title"] ?? "";
      this.start = map["start"] ?? Timestamp.now();
      this.end = map["end"] ?? Timestamp.now();
      this.source = map["source"] ?? "";
      this.sourceId = map["sourceId"] ?? "";
      this.done = map["done"] ?? false;
      this.isAllDay = map["isAllDay"] ?? false;
      this.createdOn = map["createdOn"] ?? Timestamp.now();
    } catch (e) {
      print(e);
    }
  }
}