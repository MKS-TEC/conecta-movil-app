
import 'package:cloud_firestore/cloud_firestore.dart';

class Pathology {
  String? recordId;
  String? petId;
  String? pathologyId;
  String? pathology;
  DateTime? date;
  DateTime? createdOn;

  Pathology();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "patologiaId": pathologyId,
    "patologia": pathology,
    "fechaPatologia": date,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Pathology.fromMap(Map<String, dynamic> map) {
    try {
      this.recordId = map["eid"] ?? "";
      this.pathologyId = map["patologiaId"] ?? "";
      this.pathology = map["patologia"] ?? 0;
      this.date = map["fechaPatologia"] != null ? map["fechaPatologia"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}