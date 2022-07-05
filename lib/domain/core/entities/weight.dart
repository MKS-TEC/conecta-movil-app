
import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  String? recordId;
  String? weightId;
  double? weight;
  DateTime? date;
  DateTime? createdOn;

  Weight();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "pesoId": weightId,
    "peso": weight,
    "fechaPeso": date,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Weight.fromMap(Map<String, dynamic> map) {
    try {
      this.recordId = map["eid"] ?? "";
      this.weightId = map["pesoId"] ?? "";
      this.weight = map["peso"] ?? 0;
      this.date = map["fechaPeso"] != null ? map["fechaPeso"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}