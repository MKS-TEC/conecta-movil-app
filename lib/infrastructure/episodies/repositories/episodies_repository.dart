import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/episode.dart';
import 'package:conecta/domain/core/entities/record.dart';
import 'package:conecta/domain/episode/episode_failure.dart';

@lazySingleton
class EpisodiesRepository {

  final FirebaseFirestore _firestore;

  EpisodiesRepository(this._firestore);

  Future<Either<EpisodeFailure, List<Episode>>> getEpisodies(String petId, String pathologyName) async {
    try {
      var snapshotRecords = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").limit(1).get();

      List<Episode> _episodes = List<Episode>.empty(growable: true);

      if (snapshotRecords.size == 0) return Right(_episodes);

      var record = Record.fromMap(snapshotRecords.docs[0].id, petId);

      var snapshot = await _firestore.collection("Mascotas").doc(petId).collection("Expediente").doc(record.recordId).collection("Episodios").where("diagnosticoConsulta", isEqualTo: pathologyName).orderBy("fechaEpisodio", descending: true).get();
      
      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var episode = Episode.fromMap(snapshot.data());
        _episodes.add(episode);
      }
      
      return Right(_episodes);
    } on Exception catch (e) {
      print(e);
      return left(ServerError());
    }
  }
}