
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Country {
  String? countryId;
  String? phoneCountryCode;
  List<dynamic>? cities;
  List<dynamic>? juridicIds;
  List<dynamic>? naturalIds;

  Country();

  Map<String, dynamic> toMap() => {
    "paisId": countryId,
    "codigoArea": phoneCountryCode,
    "ciudades": cities,
    "idPersonaJuridica": juridicIds,
    "idPersonaNatural": naturalIds,
  };

  Country.fromMap(Map<String, dynamic> map) {
    try {
      this.countryId = map["paisId"] ?? "";
      this.phoneCountryCode = map["codigoArea"] ?? "";
      this.cities = map["ciudades"] ?? [];
      this.juridicIds = map["idPersonaJuridica"] ?? [];
      this.naturalIds = map["idPersonaNatural"] ?? [];
    } catch (e) {
      print(e);
    }
  }
}