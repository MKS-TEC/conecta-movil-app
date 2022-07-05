import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/challenge.dart';

@lazySingleton
class IChallengeRepository {

  final FirebaseFirestore _firestore;

  IChallengeRepository(this._firestore);

  Future<Either<ChallengeFailure, List<Challenge>>> getChallenges() {
    Future<Either<ChallengeFailure, List<Challenge>>> _result = FirebaseChallengeRepository(_firestore).getChallenges();

    return _result;
  }

  Future<Either<ChallengeFailure, List<Challenge>>> getChallengesOwner(String ownerId) {
    Future<Either<ChallengeFailure, List<Challenge>>> _result = FirebaseChallengeRepository(_firestore).getChallengesOwner(ownerId);

    return _result;
  }

  Future<Either<ChallengeFailure, Challenge>> createChallengeOwner(String ownerId, Challenge challenge) {
    Future<Either<ChallengeFailure, Challenge>> _result = FirebaseChallengeRepository(_firestore).createChallengeOwner(ownerId, challenge);

    return _result;
  }

  Future<Either<ChallengeFailure, Unit>> inviteUsersChallengeOwner(String ownerId, String challengeId) {
    Future<Either<ChallengeFailure, Unit>> _result = FirebaseChallengeRepository(_firestore).inviteUsersChallengeOwner(ownerId, challengeId);

    return _result;
  }

  Future<Either<ChallengeFailure, Unit>> updateStatusChallengeOwner(String ownerId, String challengeId) {
    Future<Either<ChallengeFailure, Unit>> _result = FirebaseChallengeRepository(_firestore).updateStatusChallengeOwner(ownerId, challengeId);

    return _result;
  }

  Future<Either<ChallengeFailure, ChallengeActivity>> updateStatusChallengeActivityOwner(String ownerId, String challengeId, ChallengeActivity challengeActivity) {
    Future<Either<ChallengeFailure, ChallengeActivity>> _result = FirebaseChallengeRepository(_firestore).updateStatusChallengeActivityOwner(ownerId, challengeId, challengeActivity);

    return _result;
  }
}

class FirebaseChallengeRepository extends IChallengeRepository {
  FirebaseChallengeRepository(FirebaseFirestore firestore) : super(firestore);

  @override
  Future<Either<ChallengeFailure, List<Challenge>>> getChallenges() async {
    try {
      var snapshot =
        await _firestore.collection("Challenges").get();

      List<Challenge> _challenges = List<Challenge>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var challenge = Challenge.fromMap(snapshot.data());

        var challengesActivitiesSnapshot =
          await _firestore.collection("Challenges").doc(challenge.challengeId).collection("ChallengeActivities").get();

        List<ChallengeActivity> _challengeActivities = List<ChallengeActivity>.empty(growable: true);

        for (QueryDocumentSnapshot challengesActivitiesSnapshot in challengesActivitiesSnapshot.docs) {
          var challengeActivity = ChallengeActivity.fromMap(challengesActivitiesSnapshot.data(), challenge.challengeId ?? "");
          _challengeActivities.add(challengeActivity);
        }

        challenge.challengeActivities = _challengeActivities;
        _challenges.add(challenge);
      }
      
      return Right(_challenges);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ChallengeFailure, List<Challenge>>> getChallengesOwner(String ownerId) async {
    try {
      var snapshot =
        await _firestore.collection("Dueños").doc(ownerId).collection("Challenges").get();

      List<Challenge> _challenges = List<Challenge>.empty(growable: true);

      for (QueryDocumentSnapshot snapshot in snapshot.docs) {
        var challenge = Challenge.fromMap(snapshot.data());

        var challengesActivitiesSnapshot =
          await _firestore.collection("Dueños").doc(ownerId).collection("Challenges").doc(challenge.challengeId).collection("ChallengeActivities").get();

        List<ChallengeActivity> _challengeActivities = List<ChallengeActivity>.empty(growable: true);

        for (QueryDocumentSnapshot challengesActivitiesSnapshot in challengesActivitiesSnapshot.docs) {
          var challengeActivity = ChallengeActivity.fromMap(challengesActivitiesSnapshot.data(), challenge.challengeId ?? "");
          _challengeActivities.add(challengeActivity);
        }

        challenge.challengeActivities = _challengeActivities;
        _challenges.add(challenge);
      }
      
      return Right(_challenges);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ChallengeFailure, Challenge>> createChallengeOwner(String ownerId, Challenge challenge) async {
    try {
      await _firestore
        .collection('Dueños')
        .doc(ownerId)
        .collection("Challenges")
        .doc(challenge.challengeId)
        .set(challenge.toMap());

      if (challenge.challengeActivities!.length > 0) {
        for (var i = 0; i < challenge.challengeActivities!.length; i++) {
          await _firestore
            .collection("Dueños")
            .doc(ownerId)
            .collection("Challenges")
            .doc(challenge.challengeId)
            .collection("ChallengeActivities")
            .doc(challenge.challengeActivities?[i].challengeActivityId)
            .set(challenge.challengeActivities![i].toMap());
        }
      }

      return Right(challenge);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ChallengeFailure, Unit>> inviteUsersChallengeOwner(String ownerId, String challengeId) async {
    try {
      await _firestore
        .collection('Dueños')
        .doc(ownerId)
        .collection("Challenges")
        .doc(challengeId)
        .update({
          "status": "done"
        });

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ChallengeFailure, Unit>> updateStatusChallengeOwner(String ownerId, String challengeId) async {
    try {
      await _firestore
        .collection('Dueños')
        .doc(ownerId)
        .collection("Challenges")
        .doc(challengeId)
        .update({
          "status": "done"
        });

      return Right(unit);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ChallengeFailure, ChallengeActivity>> updateStatusChallengeActivityOwner(String ownerId, String challengeId, ChallengeActivity challengeActivity) async {
    try {
      await _firestore
        .collection('Dueños')
        .doc(ownerId)
        .collection("Challenges")
        .doc(challengeId)
        .collection("ChallengeActivities")
        .doc(challengeActivity.challengeActivityId)
        .update({
          "status": "done"
        });

      return Right(challengeActivity);
    } on Exception {
      return left(ServerError());
    }
  }
}

class MockChallengeRepository extends IChallengeRepository {
  MockChallengeRepository(FirebaseFirestore firestore) : super(firestore);

  @override
  Future<Either<ChallengeFailure, List<Challenge>>> getChallenges() async {
    try {
      final String response = await rootBundle.loadString('assets/json/challenges.json');
      final challengesData = await json.decode(response);

      List<Challenge> _challenges = List<Challenge>.empty(growable: true);

      for (Map<String, dynamic> challengeData in challengesData) {
        var challenge = Challenge.fromMap(challengeData);

        final String response = await rootBundle.loadString('assets/json/challenge-activities.json');
        final challengeActivitiesData = await json.decode(response);

        List<ChallengeActivity> _challengeActivities = List<ChallengeActivity>.empty(growable: true);

        for (Map<String, dynamic> challengeActivityData in challengeActivitiesData) {
          var challengeActivity = ChallengeActivity.fromMap(challengeActivityData, challenge.challengeId ?? "");
          _challengeActivities.add(challengeActivity);
        }

        challenge.challengeActivities = _challengeActivities;
        _challenges.add(challenge);
      }
      
      return Right(_challenges);
    } on Exception {
      return left(ServerError());
    }
  }

  Future<Either<ChallengeFailure, List<Challenge>>> getChallengesOwner(String ownerId) async {
    try {
      final String response = await rootBundle.loadString('assets/json/challenges.json');
      final challengesData = await json.decode(response);

      List<Challenge> _challenges = List<Challenge>.empty(growable: true);

      for (Map<String, dynamic> challengeData in challengesData) {
        var challenge = Challenge.fromMap(challengeData);

        final String response = await rootBundle.loadString('assets/json/challenge-activities.json');
        final challengeActivitiesData = await json.decode(response);

        List<ChallengeActivity> _challengeActivities = List<ChallengeActivity>.empty(growable: true);

        for (Map<String, dynamic> challengeActivityData in challengeActivitiesData) {
          var challengeActivity = ChallengeActivity.fromMap(challengeActivityData, challenge.challengeId ?? "");
          _challengeActivities.add(challengeActivity);
        }

        challenge.challengeActivities = _challengeActivities;
        _challenges.add(challenge);
      }
      
      return Right(_challenges);
    } on Exception {
      return left(ServerError());
    }
  }
}
