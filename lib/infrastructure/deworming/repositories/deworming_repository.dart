import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/deworming.dart';
import 'package:conecta/domain/core/entities/record.dart';
import 'package:conecta/domain/deworming/deworming_failure.dart';

@lazySingleton
class DewormingRepository {

  final FirebaseFirestore _firestore;

  DewormingRepository(this._firestore);

  Future<Either<DewormingFailure, List<Deworming>>> getDewormings(String petId) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      List<Deworming> _dewormings = List<Deworming>.empty(growable: true);

      if (snapshotRecords.size == 0) return Right(_dewormings);

      var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

      var snapshot = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(record.recordId).collection("Desparasitacion").orderBy("fechaDesparasitacion", descending: true).get();
      
      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var deworming = Deworming.fromMap(snapshot.data());
        _dewormings.add(deworming);
      }
      
      return Right(_dewormings);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<DewormingFailure, Deworming>> createDeworming(String petId, Deworming deworming) async {
   try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      if (snapshotRecords.size == 0) {
        String recordId =
          _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc().id.toString();

        deworming.recordId = recordId;

        await _firestore
          .collection("Mascotas")
          .doc(petId)
          .collection("Expediente")
          .doc(recordId)
          .set({
            "expediente_id": recordId,
            "created_on": FieldValue.serverTimestamp(),
          });
      } else {
        var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

        deworming.recordId = record.recordId;
      }

      String dewormingId =
        _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(deworming.recordId).collection("Desparasitacion").doc().id.toString();

      deworming.dewormingId = dewormingId;

      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Expediente")
        .doc(deworming.recordId)
        .collection("Desparasitacion")
        .doc(dewormingId)
        .set(deworming.toMap());

      return Right(deworming);
    } on Exception {
      return left(ServerError());
    }
  }
}