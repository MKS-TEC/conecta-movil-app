import 'package:injectable/injectable.dart';

@injectable
class PetPoint {
  String? uid;
  int? ppAccumulated;
  int? ppRedeemed;
  int? ppGenerated;

  PetPoint();

  Map<String, dynamic> toMap() => {
    "uid": uid,
    "ppAcumulados": ppAccumulated,
    "ppCanjeados": ppRedeemed,
    "ppGenerados": ppGenerated,
  };

  PetPoint.fromMap(Map<String, dynamic> map) {
    try {
      this.uid = map["uid"] ?? "";
      this.ppAccumulated = map["ppAcumulados"] ?? 0;
      this.ppRedeemed = map["ppCanjeados"] ?? 0;
      this.ppGenerated = map["ppGenerados"] ?? 0;
    } catch (e) {
      print(e);
    }
  }
}