import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/program/program_failure.dart';

@lazySingleton
class ProgramRepository {

  final FirebaseFirestore _firestore;

  ProgramRepository(this._firestore);

  Future<Either<ProgramFailure, List<Program>>> getProgramsByCategory(String programCategoryId) async {
    try {
      var snapshot =
        await _firestore.collection("Programs").where('programCategoryId', isEqualTo: programCategoryId).get();

      List<Program> programs = List<Program>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var program = Program.fromMap(snapshot.data());
        programs.add(program);
      }

      return Right(programs);
    } on Exception catch(e) {
      return left(ServerError());
    }
  }

  Future<Either<ProgramFailure, List<Program>>> getPrograms() async {
    try {
      var snapshot =
        await _firestore.collection("Programs").get();

      List<Program> _programs = List<Program>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var program = Program.fromMap(snapshot.data());

        var activitiesSnapshot =
          await _firestore.collection("Programs").doc(program.programId).collection("ProgramActivities").get();

        List<ProgramActivity> _programActivities = List<ProgramActivity>.empty(growable: true);

        for (QueryDocumentSnapshot activitiesSnapshot in activitiesSnapshot.docs) {
          var programActivity = ProgramActivity.fromMap(activitiesSnapshot.data(), program.programId ?? "");
          _programActivities.add(programActivity);
        }

        program.activities = _programActivities;
        _programs.add(program);
      }
      
      return Right(_programs);
    } on Exception {
      return left(ServerError());
    }
  }

   Future<Either<ProgramFailure, List<Program>>> getProgramsByFilters(String programCategory, Map<String, String> filters) async {
    try {
      var _programQuery = _firestore.collection("Programs").where("programCategory", isEqualTo: programCategory);

      filters.forEach((key, value) {
        _programQuery = _programQuery.where("features.$key", isEqualTo: value);
      });

      var _programSnapshots = await _programQuery.get();

      List<Program> _programs = List<Program>.empty(growable: true);

      await Future.forEach(_programSnapshots.docs, (QueryDocumentSnapshot snapshot) async {
        var program = Program.fromMap(snapshot.data());

        var activitiesSnapshot =
          await _firestore.collection("Programs").doc(program.programId).collection("ProgramActivities").get();

        List<ProgramActivity> _programActivities = List<ProgramActivity>.empty(growable: true);

        for (QueryDocumentSnapshot activitiesSnapshot in activitiesSnapshot.docs) {
          var programActivity = ProgramActivity.fromMap(activitiesSnapshot.data(), program.programId ?? "");
          _programActivities.add(programActivity);
        }

        program.activities = _programActivities;
        _programs.add(program);
      });

      return Right(_programs);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ProgramFailure, Program>> getProgram(String ownerId) async {
    try {
      var snapshot =
        await _firestore.collection("Programs").doc(ownerId).get();

      Program _program = Program();

      if (!snapshot.exists) return Right(_program);

      _program = Program.fromMap(snapshot.data()!);

      var activitiesSnapshot =
        await _firestore.collection("Programs").doc(_program.programId).collection("ProgramActivities").get();

      List<ProgramActivity> _programActivities = List<ProgramActivity>.empty(growable: true);

      for (QueryDocumentSnapshot activitiesSnapshot in activitiesSnapshot.docs) {
        var programActivity = ProgramActivity.fromMap(activitiesSnapshot.data(), _program.programId ?? "");
        _programActivities.add(programActivity);
      }

      _program.activities = _programActivities;

      return Right(_program);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ProgramFailure, List<Program>>> getProgramsPet(String petId) async {
    try {
      var snapshot =
        await _firestore.collection("Mascotas").doc(petId).collection("Programs").get();

      List<Program> _programs = List<Program>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var program = Program.fromMap(snapshot.data());

        var activitiesSnapshot =
          await _firestore.collection("Mascotas").doc(petId).collection("Programs").doc(program.programId).collection("ProgramActivities").get();

        List<ProgramActivity> _programActivities = List<ProgramActivity>.empty(growable: true);

        for (QueryDocumentSnapshot activitiesSnapshot in activitiesSnapshot.docs) {
          var programActivity = ProgramActivity.fromMap(activitiesSnapshot.data(), program.programId ?? "");
          _programActivities.add(programActivity);
        }

        program.activities = _programActivities;
        _programs.add(program);
      }
      
      return Right(_programs);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ProgramFailure, Program>> getProgramPet(String petId, String programId) async {
    try {
      var snapshot =
        await _firestore.collection("Mascotas").doc(petId).collection("Programs").doc(programId).get();

      Program _program = Program();

      if (!snapshot.exists) return Right(_program);

      _program = Program.fromMap(snapshot.data()!);

      var activitiesSnapshot =
        await _firestore.collection("Mascotas").doc(petId).collection("Programs").doc(_program.programId).collection("ProgramActivities").get();

      List<ProgramActivity> _programActivities = List<ProgramActivity>.empty(growable: true);

      for (QueryDocumentSnapshot activitiesSnapshot in activitiesSnapshot.docs) {
        var programActivity = ProgramActivity.fromMap(activitiesSnapshot.data(), _program.programId ?? "");
        _programActivities.add(programActivity);
      }

      _program.activities = _programActivities;

      return Right(_program);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ProgramFailure, Program>> createProgram(String petId, Program program) async {
    try {
      await _firestore
        .collection("Mascotas")
        .doc(petId)
        .collection("Programs")
        .doc(program.programId)
        .set(program.toMap());
      

      if (program.activities!.length > 0) {
        WriteBatch writeBatch = _firestore.batch();

        program.activities!.forEach((programActivity) {
          DocumentReference programActivityDocumentReference =
            _firestore.collection("Mascotas").doc(petId).collection("Programs").doc(program.programId).collection("ProgramActivities").doc();

            programActivity.programActivityId = programActivityDocumentReference.id.toString();
            writeBatch.set(programActivityDocumentReference, programActivity.toMap());
        });

        writeBatch.commit();
        /*for (var i = 0; i < program.activities!.length; i++) {
          await _firestore
            .collection("Mascotas")
            .doc(petId)
            .collection("Programs")
            .doc(program.programId)
            .collection("ProgramActivities")
            .doc(program.activities?[i].programActivityId)
            .set(program.activities![i].toMap());
        }*/
      }

      return Right(program);
    } on Exception {
      return left(ServerError());
    }
  }
}