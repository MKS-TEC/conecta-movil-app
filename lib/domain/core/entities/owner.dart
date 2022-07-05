import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Owner {
  String? ownerId;
  String? referredCode;
  String? name;
  String? lastName;
  String? email;
  String? phoneCountryCode;
  String? phoneNumber;
  String? country;
  String? city;
  String? personType;
  String? documentType;
  String? documentNumber;
  String? profilePictureUrl;
  File? profilePicture;

  Owner();

  Map<String, dynamic> toMap() => {
    "uid": ownerId,
    "referredCode": referredCode,
    "nombre": name,
    "apellido": lastName,
    "codigoTelefono": phoneCountryCode,
    "telefono": phoneNumber,
    "pais": country,
    "ciudad": city,
    "tipoPersona": personType,
    "tipoDocumento": documentType,
    "numeroDocumento": documentNumber,
    "email": email,
    "fotoPerfil": profilePictureUrl,
    "createdOn": FieldValue.serverTimestamp(),
  };


  Owner.fromMap(Map<String, dynamic> map) {
    try {
      this.ownerId = map["uid"] ?? "";
      this.referredCode = map["referredCode"] ?? "";
      this.name = map["nombre"] ?? "";
      this.lastName = map["apellido"] ?? "";
      this.phoneCountryCode = map["codigoTelefono"] ?? "";
      this.phoneNumber = map["telefono"] ?? "";
      this.country = map["pais"] ?? "";
      this.city = map["ciudad"] ?? "";
      this.personType = map["tipoPersona"] ?? "";
      this.documentType = map["tipoDocumento"] ?? "";
      this.documentNumber = map["numeroDocumento"] ?? "";
      this.email = map["email"] ?? "";
      this.profilePictureUrl = map["fotoPerfil"] ?? "";
    } catch (e) {
      print(e);
    }
  }
}