import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/orders/orders_event.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/core/services/day_agenda/day_agenda.dart';
import 'package:conecta/domain/core/services/service.dart';
import 'package:conecta/domain/order/order_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class OrderRepository {

  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;

  OrderRepository(this._firestore, this._sharedPreferences);
  

  Future<Either<OrdersFailure, List<NotificationModel>>> getOrders(String uid) async {
    try {
      var snapshot = await _firestore.collection("Ordenes")
        .where("uid", isEqualTo: uid).get();

      List<NotificationModel> _orders = List<NotificationModel>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var notification = NotificationModel.fromMap(snapshot.data());
        _orders.add(notification);
      }
      
      return Right(_orders);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<OrdersFailure, Unit>> updateOrderConsultation(CalendarEvent calendarEvent) async {
    try {

      await _firestore.collection("Mascotas").doc(calendarEvent.petId).collection("Calendar").doc(calendarEvent.calendarEventId).update({
        "done": false
      });

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<OrdersFailure, Unit>> setOrderConsultation(String uid, DayInAgenda dateSelected, String hourSelected, Service service, int points) async {
    try {
      String? _pet_id = _sharedPreferences.getString('SELECTED_PET_ID');

      var snapshotOwner = await _firestore.collection("Dueños").doc(uid).get();
      var snapshotPet = await _firestore.collection("Mascotas").doc(_pet_id).get();
      Pet _pet = Pet.fromMap(snapshotPet.data()!);
      Owner _owner = Owner.fromMap(snapshotPet.data()!);

      String oid = _firestore.collection("Mascotas").doc(_pet_id).collection("Calendar").doc().id.toString();
      String timeId = DateTime.now().millisecondsSinceEpoch.toString();

      await _firestore.collection("Dueños").doc(uid).collection("Petpoints").doc(uid).update({
        "ppAcumulados": points - 3000
      });

      await _firestore.collection('Mascotas').doc(_pet_id).collection("Calendar").doc(oid).set({
        "calendarEventId": oid,
        "petId": _pet_id,
        "details": "Videoconsulta pendiente a las $hourSelected",
        "title": "Videoconsulta",
        "start": dateSelected.date,
        "end": dateSelected.date,
        "source": "Videoconsulta",
        "sourceId": oid,
        "done": false,
        "isAllDay": false,
        "createdOn": FieldValue.serverTimestamp(),
      });


      dateSelected.horasDia!.removeWhere((item) => item == hourSelected);

      // DEV
      // PROD
      // await _firestore.collection('Localidades').doc("hxSe47ry5riHstMYyMxv").collection("Servicios")
      await _firestore.collection('Localidades').doc("caLB4EfOBB1orvwwnDTI").collection("Servicios")
      .doc(service.servicioId).collection("Agenda").doc(dateSelected.fecha).update({
        "horasDia": dateSelected.horasDia
      });

      var databaseReference = _firestore.collection('Ordenes').doc(timeId);
      databaseReference.set({
        "videoId": oid,
        "culqiOrderId": "",
        "aliadoId": service.aliadoId,
        "servicioid": service.servicioId,
        "oid": timeId,
        "uid": uid,
        "precio": 0,
        "tipoOrden": 'Videoconsulta',
        'createdOn': FieldValue.serverTimestamp(),
        "status": "Por confirmar",
        "statusCita": "Por confirmar",
        "mid": _pet_id,
        "fecha": dateSelected.fecha,
        "ppGeneradosD": 0,
        "date": dateSelected.date,
        "calificacion": false,
        "user": _owner.name ?? "",
        "nombreComercial": "Conecta",
        "localidadId": "caLB4EfOBB1orvwwnDTI",
        "pais": "Perú",
      });

      databaseReference.collection('Items').doc(timeId).set({
        "uid": uid,
        "nombreComercial": "Conecta",
        "petthumbnailUrl": _pet.picture,
        "titulo": "Videoconsulta",
        "oid": timeId,
        "aliadoId": service.aliadoId,
        "servicioid": service.servicioId,
        "date": dateSelected.date,
        "hora": hourSelected,
        "fecha": dateSelected.fecha,
        "precio": 0,
        "mid": _pet_id,
        "nombre": _pet.name,
      });

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }

}