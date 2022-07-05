import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module  
abstract class RegisterModule {  
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @injectable
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @injectable
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @injectable
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @injectable
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  @injectable
  GoogleSignIn get googleSignIn => GoogleSignIn();

}  