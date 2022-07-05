import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PeetRepository {

  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  final SharedPreferences _sharedPreferences;

  PeetRepository(this._firestore, this._sharedPreferences, this._firebaseStorage);

  String? getPetDefault () {
    return _sharedPreferences.getString('SELECTED_PET_ID');
  }

  Future<bool> setPetDefault (String? petId) async {
    return await _sharedPreferences.setString('SELECTED_PET_ID', petId!);
  }

  Future<Either<PetFailure, Pet>> setPet(Pet pet) async {
    try {
      String petId =
        _firestore.collection("Mascotas").doc().id.toString();

      pet.petId = petId;

      await _firestore
        .collection('Mascotas')
        .doc(petId)
        .set(pet.toMap());

      return Right(pet);
    } on Exception {
      return left(ServerError());
    }
  }

   Future<Either<PetFailure, List<Pet>>> getSubjectPets(String uid) async {
    try {
      var snapshot =
        await _firestore.collection("Mascotas").where('uid', isEqualTo: uid).get();

      List<Pet> _pets = List<Pet>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var pet = Pet.fromMap(snapshot.data());
        _pets.add(pet);
      }
      
      return Right(_pets);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<PetFailure, Pet>> getSubjectPet(String petId) async {
    try {
      var snapshot =
        await _firestore.collection("Mascotas").doc(petId).get();

      Pet pet = Pet.fromMap(snapshot.data()!);
      
      return Right(pet);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<PetFailure, Pet>> updateSubjectPet(Pet pet) async {
    try {
      if (pet.pictureFile != null) {
        String filePath = "pets/$pet.petId/pictures/${pet.pictureFile!.path.split('/').last}";
        pet.picture = await uploadFile(filePath, pet.pictureFile!);
      }

      await _firestore
        .collection('Mascotas')
        .doc(pet.petId)
        .update({
          "nombre": pet.name,
          "raza": pet.breed,
          "sexo": pet.sex,
          "foto": pet.picture,
          "fechanac": pet.birthdate,
          "descripcion": pet.about,
          "ultimaActualizacion": FieldValue.serverTimestamp(),
        });
      
      return Right(pet);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<String> uploadFile(String filepath, File file) async {
    try {
      String url = "";
      var firebaseStorageTask =
          _firebaseStorage.ref().child(filepath).putFile(file);
      await firebaseStorageTask.then((taskSnapshot) async {
        await taskSnapshot.ref.getDownloadURL().then((value) async {
          url = value;
        });
      });

      return url;
    } on Exception {
      return "";
    }
  }
}