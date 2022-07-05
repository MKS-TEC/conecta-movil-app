import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/pet/breed_failure.dart';

@lazySingleton
class BreedRepository {

  final FirebaseFirestore _firestore;

  BreedRepository(this._firestore);

  Future<Either<BreedFailure, List<Breed>>> getBreedsBySpecies(String species) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Especies').doc(species).collection('Razas').get();

      List<Breed> breeds = List<Breed>.empty(growable: true);

      for (QueryDocumentSnapshot breedSnapshot in snapshot.docs) {
        Breed breed = Breed.fromJson(breedSnapshot.id);
        breeds.add(breed);
      }

      return Right(breeds);
    } on Exception {
      return left(ServerError());
    }
  }
}