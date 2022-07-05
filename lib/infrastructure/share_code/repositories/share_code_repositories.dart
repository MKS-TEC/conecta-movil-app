import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/share_code/share_code_failure.dart';

@lazySingleton
class ShareCodeRepository {

  final FirebaseFirestore _firestore;

  ShareCodeRepository(this._firestore);

  Future<Either<ShareCodeFailure, Unit>> shareCode(Owner owner) async {
    try {

      String code = owner.referredCode.toString() != "" ? owner.referredCode.toString() : "USUARIO123";
      String msg = 'Usa mi código\n $code \ny gana 100 Pet points por registrarte en la comunidad petlover más grande de Latinoamérica. \nDescarga la app en: \nhttps://play.google.com/store/apps/details?id=com.ppa.ppet_aliado';
      // String msg = 'Hey, únete a Conecta y disfruta de todo lo que tenemos para ofrecer\n \n🐶🐱🐷🐨🐤🐸\n \nSi eres un proveedor de servicios o productos usa este enlace:\nhttps://play.google.com/store/apps/details?id=com.ppa.ppet_aliado\n \nSi eres dueño de una mascota usa este otro enlace:\nhttps://play.google.com/store/apps/details?id=com.ppa.ppet_aliado\n \nEn ambos casos usa el código \n$code\n para que apoyes al aliado';
      final FlutterShareMe flutterShareMe = FlutterShareMe();
      await flutterShareMe.shareToSystem(msg: msg);

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }
  
  Future<Either<ShareCodeFailure, Unit>> redeemUserCode(String code) async {
    try {

      var snapshot = await _firestore.collection("Dueños")
      .where("referredCode", isEqualTo: code).get();
      Owner _owner = Owner.fromMap(snapshot.docs[0].data());

      await _firestore.collection("Referrals").doc(_owner.ownerId).update({
        "guestUsers": FieldValue.increment(1)
      });

      // await _firestore.collection("Dueños").doc(_owner.ownerId).collection("Petpoints").doc(_owner.ownerId).update({
      //   "ppAcumulados": FieldValue.increment(1500)
      // });

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }
  
  Future<Either<ShareCodeFailure, int>> getNumberOfGuests(String uid) async {
    try {

      var snapshot = await _firestore.collection("Referrals").doc(uid).get();
      int number = snapshot.data()!["guestUsers"];

      return Right(number);
    } on Exception {
      return left(ServerError());
    }
  }

}