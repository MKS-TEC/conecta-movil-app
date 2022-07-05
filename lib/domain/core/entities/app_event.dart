import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppEvent {
  String? appEventId;
  String? name;
  DateTime? createdOn;

  AppEvent();

  Map<String, dynamic> toMap() => {
    "appEventId": appEventId,
    "name": name,
    "createdOn": FieldValue.serverTimestamp(),
  };

  AppEvent.fromMap(Map<String, dynamic> map) {
    try {
      this.appEventId = map["appEventId"] ?? "";
      this.name = map["name"] ?? "";
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}