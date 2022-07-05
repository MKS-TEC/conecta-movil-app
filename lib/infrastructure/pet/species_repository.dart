
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/species.dart';
import 'package:conecta/domain/pet/species_failure.dart';

@lazySingleton
class SpeciesRepository {

  final FirebaseFirestore _firestore;

  SpeciesRepository(this._firestore);

  Future<Either<SpeciesFailure, List<Species>>> getSpecies() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Especies').get();

      List<Species> species = List<Species>.empty(growable: true);

      for (QueryDocumentSnapshot speciesSnapshot in snapshot.docs) {
        Species specie =
              Species.fromJson(speciesSnapshot.id);

        species.add(specie);
      }

      return Right(species);
    } on Exception {
      return left(ServerError());
    }
  }
}