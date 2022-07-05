import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class Challenge {
  String? challengeId;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  int? gamificationPoints;
  int? marketPoints;
  String? imageUrl;
  String? status;
  List<ChallengeActivity>? challengeActivities;
  DateTime? createdOn;

  Challenge();

  Map<String, dynamic> toMap() => {
    "challengeId": challengeId,
    "title": title,
    "description": description,
    "startDate": startDate,
    "endDate": endDate,
    "gamificationPoints": gamificationPoints,
    "marketPoints": marketPoints,
    "imageUrl": imageUrl,
    "status": status,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Challenge.fromMap(Map<String, dynamic> map) {
    try {
      this.challengeId = map["challengeId"] ?? "";
      this.title = map["title"] ?? "";
      this.description = map["description"] ?? "";
      this.gamificationPoints = map["gamificationPoints"] != null ? map["gamificationPoints"] : 0;
      this.marketPoints = map["marketPoints"] != null ? map["marketPoints"] : 0;
      this.imageUrl = map["imageUrl"] != null ? map["imageUrl"] : 0;
      this.status = map["status"] ?? "pending";
      this.startDate = map["startDate"] != null ? map["startDate"].toDate() : null;
      this.endDate = map["endDate"] != null ? map["endDate"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}

@injectable
class ChallengeActivity {
  String? challengeId;
  String? challengeActivityId;
  String? title;
  String? status;
  String? associatedAppEvent;
  DateTime? createdOn;

  ChallengeActivity();

  Map<String, dynamic> toMap() => {
    "challengeId": challengeId,
    "challengeActivityId": challengeActivityId,
    "title": title,
    "associatedAppEvent": associatedAppEvent,
    "createdOn": FieldValue.serverTimestamp(),
  };

  ChallengeActivity.fromMap(Map<String, dynamic> map, String challengeId) {
    try {
      this.challengeId = challengeId;
      this.challengeActivityId = map["challengeActivityId"] ?? "";
      this.title = map["title"] ?? "";
      this.associatedAppEvent = map["associatedAppEvent"] ?? "";
      this.status = map["status"] ?? "pending";
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}