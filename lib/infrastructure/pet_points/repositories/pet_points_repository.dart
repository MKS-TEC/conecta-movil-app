import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/pet_points.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';

@lazySingleton
class IPetPointRepository {

  final FirebaseFirestore _firestore;

  IPetPointRepository(this._firestore);

  Future<Either<PetPointFailure, PetPoint>> getPetPoints(String ownerId) {
    Future<Either<PetPointFailure, PetPoint>> _result = FirebasePetPointRepository(_firestore).getPetPoints(ownerId);

    return _result;
  }

  Future<Either<PetPointFailure, Unit>> updatePetPoints(String ownerId, int petPointsQuantity) {
    Future<Either<PetPointFailure, Unit>> _result = FirebasePetPointRepository(_firestore).updatePetPoints(ownerId, petPointsQuantity);

    return _result;
  }
}

class FirebasePetPointRepository extends IPetPointRepository {
  FirebasePetPointRepository(FirebaseFirestore firestore) : super(firestore);

  @override
  Future<Either<PetPointFailure, PetPoint>> getPetPoints(String ownerId) async {
    try {
      var snapshot =
        await _firestore.collection("Dueños").doc(ownerId).collection("Petpoints").doc(ownerId).get();

      PetPoint _petPoint = PetPoint();

      if (!snapshot.exists) return Right(_petPoint);

      _petPoint = PetPoint.fromMap(snapshot.data()!);
      
      return Right(_petPoint);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<PetPointFailure, Unit>> updatePetPoints(String ownerId, int petPointsQuantity) async {
    try {
      var snapshot =
        await _firestore.collection("Dueños").doc(ownerId).collection("Petpoints").doc(ownerId).get();

      if (!snapshot.exists) {
        await _firestore
          .collection('Dueños')
          .doc(ownerId)
          .collection("Petpoints")
          .doc(ownerId)
          .set({
            "uid": ownerId,
            "ppAcumulados": petPointsQuantity,
            "ppCanjeados": 0,
            "ppGenerados": 0,
          });
      } else {
        await _firestore
          .collection('Dueños')
          .doc(ownerId)
          .collection("Petpoints")
          .doc(ownerId)
          .update({
            "ppAcumulados": FieldValue.increment(petPointsQuantity)
          });
      }

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }
}

class MockPetPointRepository extends IPetPointRepository {
  MockPetPointRepository(FirebaseFirestore firestore) : super(firestore);
}
