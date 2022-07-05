import 'package:cloud_firestore/cloud_firestore.dart';

class DayInAgenda {
  String? agendaId;
  String? day;
  String? month;
  String? year;
  String? fecha;
  String? promoId;
  Timestamp? createdOn, date;
  List<dynamic>? horasDia;

  DayInAgenda();

  DayInAgenda.fromMap(Map<String, dynamic> map) {
    try{
      this.agendaId = map['agendaId'] ?? "";
      this.day = map['day'] ?? "";
      this.month = map['month'] ?? "";
      this.year = map['year'] ?? "";
        this.createdOn = map['createdOn'] ?? Timestamp.now();
        this.date = map['date'] ?? Timestamp.now();
        this.fecha = map['fecha'] ?? "";
        this.horasDia = map['horasDia'] ?? [];
        this.promoId = map['promoId'] ?? "";
    }catch(e){
      print(e);
    }
  }

}
