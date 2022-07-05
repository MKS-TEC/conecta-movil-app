import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/diagnose.dart';
import 'package:conecta/domain/core/entities/record.dart';
import 'package:conecta/domain/diagnosis/diagnosis_failure.dart';

@lazySingleton
class DiagnosisRepository {

  final FirebaseFirestore _firestore;

  DiagnosisRepository(this._firestore);

  Future<Either<DiagnosisFailure, List<Diagnose>>> getDiagnosis(String petId) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      List<Diagnose> _diagnosis = List<Diagnose>.empty(growable: true);

      if (snapshotRecords.size == 0) return Right(_diagnosis);

      var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

      var snapshot = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(record.recordId).collection("Diagnostico").orderBy("fechaDiagnostico", descending: true).get();
      
      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var diagnose = Diagnose.fromMap(snapshot.data());
        _diagnosis.add(diagnose);
      }
      
      return Right(_diagnosis);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<DiagnosisFailure, Diagnose>> createDiagnose(String petId, Diagnose diagnose) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      if (snapshotRecords.size == 0) {
        String recordId =
          _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc().id.toString();

        diagnose.recordId = recordId;

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

        diagnose.recordId = record.recordId;
      }

      String diagnoseId =
        _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(diagnose.recordId).collection("Diagnostico").doc().id.toString();

      diagnose.diagnoseId = diagnoseId;

      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Expediente")
        .doc(diagnose.recordId)
        .collection("Patologia")
        .doc(diagnoseId)
        .set(diagnose.toMap());

      return Right(diagnose);
    } on Exception {
      return left(ServerError());
    }
  }
}