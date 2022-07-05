import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/pet_calendar/pet_calendar.dart';
import 'package:conecta/domain/pet_calendar/pet_calendar_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PetCalendarRepository {

  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;

  PetCalendarRepository(this._firestore, this._sharedPreferences);

  Future<Either<PetCalendarFailure, List<PetCalendarItem>>> getPetCalendar(String uid) async {
    String? _pet_id = _sharedPreferences.getString('SELECTED_PET_ID');
    try {
      var snapshot = await _firestore.collection("Mascotas")
        .doc(_pet_id).collection("Calendar").get();

      List<PetCalendarItem> _pet_calendar_list = List<PetCalendarItem>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var _pet_calendar = PetCalendarItem.fromMap(snapshot.data());
        _pet_calendar_list.add(_pet_calendar);
      }
      
      return Right(_pet_calendar_list);
    } on Exception {
      return left(ServerError());
    }
  }
}