import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/services/day_agenda/day_agenda.dart';
import 'package:conecta/domain/core/services/service.dart';
import 'package:conecta/domain/services/service_failure.dart';

@lazySingleton
class ServicesRepository {

  final FirebaseFirestore _firestore;

  ServicesRepository(this._firestore);

  Future<Either<ServiceFailure, List<Service>>> getServices() async {
    try {
      var snapshot = await _firestore.collectionGroup("Servicios").get();

      List<Service> _services = List<Service>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var service = Service.fromMap(snapshot.data());
        _services.add(service);
      }
      
      return Right(_services);
    } on Exception {
      return left(ServerError());
    }
  }
  
  Future<Either<ServiceFailure, Service>> getVideoConsultingService() async {
    try {
      
      //PROD
      var snapshotService = await _firestore.collection("Localidades").doc("caLB4EfOBB1orvwwnDTI").collection("Servicios").doc("eBX4Isnnemwg0qTvUp4h").get();
      var snapshotDaysInService = await _firestore.collection("Localidades").doc("caLB4EfOBB1orvwwnDTI").
                                        collection("Servicios").doc("eBX4Isnnemwg0qTvUp4h").collection("Agenda").orderBy("date").get();
      
      // DEV
      
      // var snapshotService = await _firestore.collection("Localidades").doc("hxSe47ry5riHstMYyMxv").collection("Servicios").doc("CzNW0X1HxWWa0zTot6Qy").get();
      // var snapshotDaysInService = await _firestore.collection("Localidades").doc("hxSe47ry5riHstMYyMxv").
      //                                   collection("Servicios").doc("CzNW0X1HxWWa0zTot6Qy").collection("Agenda").orderBy("date").get();

      Service _service = Service.fromMap(snapshotService.data()!);
      List<DayInAgenda> _list_days = List<DayInAgenda>.empty(growable: true);
      int todayMili = DateTime.now().millisecondsSinceEpoch;

      for (QueryDocumentSnapshot daySnapshot in snapshotDaysInService.docs) {
        var _months = [
          "Enero",
          "Febrero",
          "Marzo",
          "Abril",
          "Mayo",
          "Junio",
          "Julio",
          "Agosto",
          "Septiembre",
          "Octubre",
          "Noviembre",
          "Diciembre"
        ];

        var day = DayInAgenda.fromMap(daySnapshot.data());
        var i = DateFormat("M").format(day.date!.toDate());
        
        day.day = DateFormat("dd").format(day.date!.toDate());
        day.month = _months[int.parse(i) - 1];
        day.year = DateFormat("yyyy").format(day.date!.toDate());

        if(todayMili <= day.date!.millisecondsSinceEpoch){
          _list_days.add(day);
        }

      }

      _service.days_agenda = _list_days;
      
      return Right(_service);
    } on Exception {
      return left(ServerError());
    }
  }

}