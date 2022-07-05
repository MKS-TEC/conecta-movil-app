import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/record.dart';
import 'package:conecta/domain/core/entities/vaccine.dart';
import 'package:conecta/domain/vaccine/vaccine_failure.dart';

@lazySingleton
class VaccinesRepository {

  final FirebaseFirestore _firestore;

  VaccinesRepository(this._firestore);

  Future<Either<VaccineFailure, List<Vaccine>>> getVaccines(String petId) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      List<Vaccine> _vaccines = List<Vaccine>.empty(growable: true);

      if (snapshotRecords.size == 0) return Right(_vaccines);

      var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

      var snapshot = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(record.recordId).collection("Vacunas").orderBy("fechaVacuna", descending: true).get();
      
      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var vaccine = Vaccine.fromMap(snapshot.data());
        _vaccines.add(vaccine);
      }
      
      return Right(_vaccines);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<VaccineFailure, Vaccine>> createVaccine(String petId, Vaccine vaccine) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      if (snapshotRecords.size == 0) {
        String recordId =
          _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc().id.toString();

        vaccine.recordId = recordId;

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

        vaccine.recordId = record.recordId;
      }

      String vaccineId =
        _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(vaccine.recordId).collection("Vacunas").doc().id.toString();

      vaccine.vaccineId = vaccineId;

      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Expediente")
        .doc(vaccine.recordId)
        .collection("Vacunas")
        .doc(vaccineId)
        .set(vaccine.toMap());

      return Right(vaccine);
    } on Exception {
      return left(ServerError());
    }
  }
}