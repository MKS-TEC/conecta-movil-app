
import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccine {
  String? recordId;
  String? vaccineId;
  String? type;
  DateTime? date;
  DateTime? createdOn;

  Vaccine();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "vacunaId": vaccineId,
    "tipoVacuna": type,
    "fechaVacuna": date,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Vaccine.fromMap(Map<String, dynamic> map) {
    try {
      this.recordId = map["eid"] ?? "";
      this.vaccineId = map["vacunaId"] ?? "";
      this.type = map["tipoVacuna"] ?? "";
      this.date = map["fechaVacuna"] != null ? map["fechaVacuna"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}