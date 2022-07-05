
import 'package:cloud_firestore/cloud_firestore.dart';

class Diagnose {
  String? recordId;
  String? diagnoseId;
  String? diagnose;
  DateTime? date;
  DateTime? createdOn;

  Diagnose();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "diagnosticoId": diagnoseId,
    "diagnostico": diagnose,
    "fechaDiagnostico": date,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Diagnose.fromMap(Map<String, dynamic> map) {
    try {
      this.recordId = map["eid"] ?? "";
      this.diagnoseId = map["diagnosticoId"] ?? "";
      this.diagnose = map["diagnostico"] ?? 0;
      this.date = map["fechaDiagnostico"] != null ? map["fechaDiagnostico"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}