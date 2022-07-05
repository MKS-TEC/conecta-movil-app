import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/record.dart';
import 'package:conecta/domain/core/entities/temperature.dart';
import 'package:conecta/domain/temperature/temperature_failure.dart';

@lazySingleton
class TemperatureRepository {

  final FirebaseFirestore _firestore;

  TemperatureRepository(this._firestore);

  Future<Either<TemperatureFailure, List<Temperature>>> getTemperatures(String petId) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      List<Temperature> _temperatures = List<Temperature>.empty(growable: true);

      if (snapshotRecords.size == 0) return Right(_temperatures);

      var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

      var snapshot = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(record.recordId).collection("Temperatura").orderBy("fechaTemperatura", descending: true).get();
      
      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var temperature = Temperature.fromMap(snapshot.data());
        _temperatures.add(temperature);
      }
      
      return Right(_temperatures);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<TemperatureFailure, Temperature>> createTemperature(String petId, Temperature temperature) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      if (snapshotRecords.size == 0) {
        String recordId =
          _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc().id.toString();

        temperature.recordId = recordId;

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

        temperature.recordId = record.recordId;
      }

      String temperatureId =
        _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(temperature.recordId).collection("Temperatura").doc().id.toString();

      temperature.temperatureId = temperatureId;

      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Expediente")
        .doc(temperature.recordId)
        .collection("Temperatura")
        .doc(temperatureId)
        .set(temperature.toMap());

      return Right(temperature);
    } on Exception {
      return left(ServerError());
    }
  }
}