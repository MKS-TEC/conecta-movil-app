import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/record.dart';
import 'package:conecta/domain/core/entities/weight.dart';
import 'package:conecta/domain/weight/weight_failure.dart';

@lazySingleton
class WeightsRepository {

  final FirebaseFirestore _firestore;

  WeightsRepository(this._firestore);

  Future<Either<WeightFailure, List<Weight>>> getWeights(String petId) async {
   try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      List<Weight> _weights = List<Weight>.empty(growable: true);

      if (snapshotRecords.size == 0) return Right(_weights);

      var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

      var snapshot = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(record.recordId).collection("Peso").orderBy("fechaPeso", descending: true).get();
      
      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var weight = Weight.fromMap(snapshot.data());
        _weights.add(weight);
      }
      
      return Right(_weights);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<WeightFailure, Weight>> createWeight(String petId, Weight weight) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      if (snapshotRecords.size == 0) {
        String recordId =
          _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc().id.toString();

        weight.recordId = recordId;

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

        weight.recordId = record.recordId;
      }

      String weightId =
        _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(weight.recordId).collection("Peso").doc().id.toString();

      weight.weightId = weightId;

      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Expediente")
        .doc(weight.recordId)
        .collection("Peso")
        .doc(weightId)
        .set(weight.toMap());

      return Right(weight);
    } on Exception {
      return left(ServerError());
    }
  }
}