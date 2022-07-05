import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class InitialConfigurationFacade {
  
  final FirebaseFirestore _firebaseFirestore;

  InitialConfigurationFacade(this._firebaseFirestore);
}