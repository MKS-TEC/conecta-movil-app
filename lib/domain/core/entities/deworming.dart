
import 'package:cloud_firestore/cloud_firestore.dart';

class Deworming {
  String? recordId;
  String? dewormingId;
  DateTime? date;
  DateTime? createdOn;

  Deworming();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "desparacitacionId": dewormingId,
    "fechaDesparasitacion": date,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Deworming.fromMap(Map<String, dynamic> map) {
    try {
      this.recordId = map["eid"] ?? "";
      this.dewormingId = map["desparacitacionId"] ?? "";
      this.date = map["fechaDesparasitacion"] != null ? map["fechaDesparasitacion"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}