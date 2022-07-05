
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/auth/auth_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

@lazySingleton
class AuthFacade {

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPreferences;
  final GoogleSignIn _googleSignin;

  AuthFacade(this._firebaseAuth, this._sharedPreferences, this._firestore, this._googleSignin);

  Future<Option<User>> getSignedInUser() async {
    return optionOf(_firebaseAuth.currentUser);
  } 

  bool isFirstTimeUsingApp () {
    return !_sharedPreferences.containsKey('FIRST_TIME_USING_APP');
  }

  Future<bool> firstTimeUsingAppDone () async {
    return await _sharedPreferences.setBool('FIRST_TIME_USING_APP', true);
  }

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String? name
  }) async {
    try {

      var rng = new Random();    
      var numberPart = rng.nextInt(1000);
      var loweCaseName = name?.toLowerCase();
      var loweCaseNameFormatted = loweCaseName!.replaceAll(" ", "");
      
      var referredCode = loweCaseNameFormatted + numberPart.toString();

      // Registrar el usuario con email y clave
      var userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
      await userCredential.user?.updateDisplayName(name);

      await _firestore
        .collection("Dueños")
        .doc(userCredential.user?.uid)
        .set({
          "uid": userCredential.user?.uid,
          "nombre": name,
          "email": emailAddress,
          "referredCode": referredCode,
          "createdOn": FieldValue.serverTimestamp(),
        });
    
      await _firestore
        .collection("Referrals")
        .doc(userCredential.user?.uid)
        .set({
          "uid": userCredential.user?.uid,
          "referredCode": referredCode,
          "guestUsers": 0,
          "createdOn": FieldValue.serverTimestamp(),
        });

      return right(unit);
        
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(EmailAlreadyInUse());
      } else {
        return left(ServerError());
      }
    }
  }

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await _firebaseAuth
        .signInWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return left(InvalidEmailAndPasswordCombination());
      }
      return left(ServerError());
    }
  }

  Future<Either<AuthFailure, User?>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential)
        .then((userCredential) => right(userCredential.user));
    } on PlatformException catch(e) {
      return left(ServerError());
    }
  }

  Future<void> signOut() async {
    await _googleSignin.signOut();
    await _firebaseAuth.signOut();
  }


}