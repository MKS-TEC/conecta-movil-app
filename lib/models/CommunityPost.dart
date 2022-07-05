import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de la publicación en la comunidad
class CommunityPostModel{
  late String comunidadId;
  late String postId;
  late int vistas;
  late String creadorId;
  late String estado;
  late String urlImagen;
  late String titulo;
  late String descripcion;
  late int likes;
  late List<dynamic> palabrasClave;
  late Timestamp createdOn;

  CommunityPostModel({
    required this.comunidadId,
    required this.postId,
    required this.vistas,
    required this.creadorId,
    required this.estado,
    required this.urlImagen,
    required this.titulo,
    required this.descripcion,
    required this.likes,
    required this.palabrasClave,
    required this.createdOn
  });

  CommunityPostModel.fromJson(Map<String, dynamic> json){
    comunidadId = json['comunidadId'];
    postId = json['postId'];
    vistas = json['vistas'];
    creadorId = json['creadorId'];
    estado = json['estado'];
    urlImagen = json['urlImagen'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    likes = json['likes'];
    palabrasClave = json['palabrasClave'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['comunidadId'] = this.comunidadId;
    data['postId'] = this.postId;
    data['vistas'] = this.vistas;
    data['creadorId'] = this.creadorId;
    data['estado'] = this.estado;
    data['urlImagen'] = this.urlImagen;
    data['titulo'] = this.titulo;
    data['descripcion'] = this.descripcion;
    data['likes'] = this.likes;
    data['palabrasClave'] = this.palabrasClave;
    data['createdOn'] = this.createdOn;

    return data;
  }
}