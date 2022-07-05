import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de la comunidad
class CommunityModel{
  late String comunidadId;
  late String creadorId;
  late String estado;
  late String urlImagen;
  late String titulo;
  late String descripcion;
  late List<dynamic> miembros;
  late List<dynamic> palabrasClave;
  late Timestamp createdOn;

  CommunityModel({
    required this.comunidadId,
    required this.creadorId,
    required this.estado,
    required this.urlImagen,
    required this.titulo,
    required this.descripcion,
    required this.miembros,
    required this.palabrasClave,
    required this.createdOn
  });

  CommunityModel.fromJson(Map<String, dynamic> json){
    comunidadId = json['comunidadId'];
    creadorId = json['creadorId'];
    estado = json['estado'];
    urlImagen = json['urlImagen'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    miembros = json['miembros'];
    palabrasClave = json['palabrasClave'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['comunidadId'] = this.comunidadId;
    data['creadorId'] = this.creadorId;
    data['estado'] = this.estado;
    data['urlImagen'] = this.urlImagen;
    data['titulo'] = this.titulo;
    data['descripcion'] = this.descripcion;
    data['miembros'] = this.miembros;
    data['palabrasClave'] = this.palabrasClave;
    data['createdOn'] = this.createdOn;

    return data;
  }
}