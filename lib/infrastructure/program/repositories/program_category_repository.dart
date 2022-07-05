import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/program_category.dart';
import 'package:conecta/domain/program/program_category_failure.dart';

@lazySingleton
class ProgramCategoryRepository {
  final FirebaseFirestore _firestore;

  ProgramCategoryRepository(this._firestore);

  Future<Either<ProgramCategoryFailure, List<ProgramCategory>>> getMainProgramCategories() async {
    try {
      var snapshot =
        await _firestore.collection("ProgramsCategories").where('level', isEqualTo: 1).get();

      List<ProgramCategory> programCategories = List<ProgramCategory>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var programCategory = ProgramCategory.fromMap(snapshot.data());
        programCategories.add(programCategory);
      }

      return Right(programCategories);
    } on Exception {
      return left(ProgramCategoryFailure.serverError());
    }
  }

  Future<Either<ProgramCategoryFailure, List<ProgramCategory>>> getProgramCategoriesByMainCategory(String mainProgramCategoryId) async {
    try {
      var snapshot =
        await _firestore.collection("ProgramsCategories").where('parentId', isEqualTo: mainProgramCategoryId).get();

      List<ProgramCategory> programCategories = List<ProgramCategory>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var programCategory = ProgramCategory.fromMap(snapshot.data());
        programCategories.add(programCategory);
      }

      return Right(programCategories);
    } on Exception {
      return left(ProgramCategoryFailure.serverError());
    }
  }

  Future<Either<ProgramCategoryFailure, List<ProgramCategory>>> getProgramCategories() async {
    try {
      var snapshot =
        await _firestore.collection("ProgramsCategories").where('level', isEqualTo: 2).get();

      List<ProgramCategory> programCategories = List<ProgramCategory>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var programCategory = ProgramCategory.fromMap(snapshot.data());
        programCategories.add(programCategory);
      }

      return Right(programCategories);
    } on Exception {
      return left(ProgramCategoryFailure.serverError());
    }
  }
}