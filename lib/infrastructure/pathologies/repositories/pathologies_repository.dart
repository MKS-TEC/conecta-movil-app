import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/pathology.dart';
import 'package:conecta/domain/core/entities/record.dart';
import 'package:conecta/domain/pathology/pathology_failure.dart';

@lazySingleton
class PathologiesRepository {

  final FirebaseFirestore _firestore;

  PathologiesRepository(this._firestore);

  Future<Either<PathologyFailure, List<Pathology>>> getPathologies(String petId) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      List<Pathology> _pathologies = List<Pathology>.empty(growable: true);

      if (snapshotRecords.size == 0) return Right(_pathologies);

      var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

      var snapshot = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(record.recordId).collection("Patologia").orderBy("fechaPatologia", descending: true).get();
      
      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var pathology = Pathology.fromMap(snapshot.data());
        _pathologies.add(pathology);
      }
      
      return Right(_pathologies);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<PathologyFailure, Pathology>> createPathology(String petId, Pathology pathology) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      if (snapshotRecords.size == 0) {
        String recordId =
          _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc().id.toString();

        pathology.recordId = recordId;

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

        pathology.recordId = record.recordId;
      }

      String pathologyId =
        _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(pathology.recordId).collection("Patologia").doc().id.toString();

      pathology.pathologyId = pathologyId;

      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Expediente")
        .doc(pathology.recordId)
        .collection("Patologia")
        .doc(pathologyId)
        .set(pathology.toMap());

      return Right(pathology);
    } on Exception {
      return left(ServerError());
    }
  }
}