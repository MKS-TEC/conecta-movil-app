
import 'package:cloud_firestore/cloud_firestore.dart';

class Temperature {
  String? recordId;
  String? temperatureId;
  double? temperature;
  DateTime? date;
  DateTime? createdOn;

  Temperature();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "temperaturaId": temperatureId,
    "temperatura": temperature,
    "fechaTemperatura": date,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Temperature.fromMap(Map<String, dynamic> map) {
    try {
      this.recordId = map["eid"] ?? "";
      this.temperatureId = map["temperaturaId"] ?? "";
      this.temperature = map["temperatura"] ?? 0;
      this.date = map["fechaTemperatura"] != null ? map["fechaTemperatura"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}