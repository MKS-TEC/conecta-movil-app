
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String? recordId;
  String? petId;

  Record();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "mid": petId,
    "created_on": FieldValue.serverTimestamp(),
  };

  Record.fromMap(String recordId, String petId) {
    try {
      this.recordId = recordId;
      this.petId = petId;
    } catch (e) {
      print(e);
    }
  }
}