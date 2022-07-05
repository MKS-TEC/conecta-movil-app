import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/country.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/owner/owner_failure.dart';

@lazySingleton
class OwnerRepository {

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  OwnerRepository(this._firestore, this._firebaseStorage, this._firebaseAuth);

  Future<Either<OwnerFailure, Owner>> getOwner(String ownerId) async {
    try {
      var snapshot =
        await _firestore.collection("Dueños").doc(ownerId).get();

      Owner _owner = Owner();

      if (!snapshot.exists) return left(OwnerNotFound());

      _owner = Owner.fromMap(snapshot.data()!);
      
      return Right(_owner);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<OwnerFailure, int>> getOwnerPoints(String ownerId) async {
    try {
      var snapshot = await _firestore.collection("Dueños").doc(ownerId).collection("Petpoints").doc(ownerId).get();

      int points = snapshot.data()!["ppAcumulados"];
      
      return Right(points);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<OwnerFailure, Owner>> getOwnerWithEmail(String email) async {
    try {
      var snapshot =
        await _firestore.collection("Dueños").where("email", isEqualTo: email).limit(1).get();

      if (snapshot.size == 0) return left(OwnerNotFound());

      Owner _owner = Owner.fromMap(snapshot.docs[0].data());
      
      return Right(_owner);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<OwnerFailure, Unit>> setOwner(Owner owner) async {
    try {
      await _firestore
        .collection("Dueños")
        .doc(owner.ownerId)
        .set(owner.toMap());

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<OwnerFailure, Unit>> setOwnerProfilePicture(String ownerId, File file) async {
    try {
      var user = _firebaseAuth.currentUser;

      String filePath = "owners/$ownerId/profilePictures/$file.path";
      var profilePictureUrl = await uploadFile(filePath, file);

      await _firestore
        .collection("Dueños")
        .doc(ownerId)
        .update({
          'profile_picture_url': profilePictureUrl,
        });

      await user?.updatePhotoURL(profilePictureUrl);

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<OwnerFailure, Owner>> updateSubjectOwner(Owner owner) async {
    try {
      var user = _firebaseAuth.currentUser;

      if (owner.profilePicture != null) {
        String filePath = "owners/$owner.ownerId/profilePictures/${owner.profilePicture!.path.split('/').last}";
        owner.profilePictureUrl = await uploadFile(filePath, owner.profilePicture!);
      }

      var snapshot =
        await _firestore.collection("Dueños").doc(owner.ownerId).get();

      if (!snapshot.exists) {
        await _firestore
        .collection('Dueños')
        .doc(owner.ownerId)
        .set({
          "uid": owner.ownerId,
          "nombre": owner.name,
          "apellido": owner.lastName,
          "codigoTelefono": owner.phoneCountryCode,
          "telefono": owner.phoneNumber,
          "pais": owner.country,
          "ciudad": owner.city,
          "tipoPersona": owner.personType,
          "tipoDocumento": owner.documentType,
          "numeroDocumento": owner.documentNumber,
          "fotoPerfil": owner.profilePictureUrl,
          "email": user?.email,
          "ultimaActualizacion": FieldValue.serverTimestamp(),
          "createdOn": FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore
          .collection('Dueños')
          .doc(owner.ownerId)
          .update({
            "nombre": owner.name,
            "apellido": owner.lastName,
            "codigoTelefono": owner.phoneCountryCode,
            "telefono": owner.phoneNumber,
            "pais": owner.country,
            "ciudad": owner.city,
            "tipoPersona": owner.personType,
            "tipoDocumento": owner.documentType,
            "numeroDocumento": owner.documentNumber,
            "fotoPerfil": owner.profilePictureUrl,
            "ultimaActualizacion": FieldValue.serverTimestamp(),
          });
      }

      await user?.updateDisplayName('${owner.name} ${owner.lastName}');
      await user?.updatePhotoURL(owner.profilePictureUrl);
      
      return Right(owner);
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
  
  Future<Either<OwnerFailure, List<Country>>> getCountries() async {
    try {
      var snapshot = await _firestore.collection("Ciudades").get();

      List<Country> _countries = List<Country>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var country = Country.fromMap(snapshot.data());
        _countries.add(country);
      }
      
      return Right(_countries);
    } on Exception {
      return left(ServerError());
    }
  }
}