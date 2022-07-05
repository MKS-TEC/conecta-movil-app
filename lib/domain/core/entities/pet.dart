
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String? petId;
  String? userId;
  String? name;
  String? species;
  String? breed;
  String? sex;
  String? about;
  String? picture;
  File? pictureFile;
  DateTime? birthdate; 
  DateTime? createdOn;

  Pet();

  Map<String, dynamic> toMap() => {
    "mid": petId,
    "uid": userId,
    "nombre": name,
    "especie": species,
    "raza": breed,
    "sexo": sex,
    "foto": picture,
    "fechanac": birthdate,
    "descripcion": about,
    "created_on": FieldValue.serverTimestamp(),
  };

  Pet.fromMap(Map<String, dynamic> map) {
    try {
      this.petId = map["mid"] ?? "";
      this.userId = map["uid"] ?? "";
      this.name = map["nombre"] ?? "";
      this.species = map["especie"] ?? "";
      this.breed = map["raza"] ?? "";
      this.sex = map["sexo"] ?? "";
      this.picture = map["foto"] ?? "";
      this.birthdate = map["fechanac"] != null ? map["fechanac"].toDate() : null;
      this.about = map["descripcion"] ?? "";
      this.createdOn = map["created_on"] != null ? map["created_on"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}