import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conecta/domain/core/services/day_agenda/day_agenda.dart';

class Service {
  String? titulo,
      aliadoId,
      servicioId,
      categoria,
      descripcion,
      condiciones,
      urlImagen,
      ciudad,
      direccion;
  dynamic capacidad, delivery, precio, domicilio, totalRatings, countRatings;
  Timestamp? createdOn;
  bool? activo;
  List<DayInAgenda>? days_agenda;

  Service();

  Service.fromMap(Map<String, dynamic> map) {
    try{
      this.titulo = map['titulo'] ?? "";
      this.aliadoId = map['aliadoId'] ?? "";
      this.servicioId = map['servicioId'] ?? "";
      this.categoria = map['categoria'] ?? "";
      this.descripcion = map['descripcion'] ?? "";
      this.condiciones = map['condiciones'] ?? "";
      this.urlImagen = map['urlImagen'] ?? "";
      this.capacidad = map['capacidad'] ?? "";
      this.precio = map['precio'] ?? "";
      this.delivery = map['delivery'] ?? "";
      this.domicilio = map['domicilio'] ?? "";
      this.activo = map['activo'] ?? false;
      this.createdOn = map['createdOn'] ?? Timestamp.now();
      this.ciudad = map['ciudad'] ?? "";
      this.direccion = map['direccion'] ?? "";
      this.countRatings = map['countRatings'] ?? "";
      this.totalRatings = map['totalRatings'] ?? "";
      this.days_agenda = map['days_agenda'] ?? [];
    }catch(e){
      print(e);
    }
  }

}
