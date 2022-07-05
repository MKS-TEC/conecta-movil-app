import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProgramFeatures {
  String? species;
  String? breed;

  ProgramFeatures();

  ProgramFeatures.fromMap(Map<String, dynamic> map) {
    try {
      this.species = map["species"] ?? "";
      this.breed = map["breed"] ?? "";
    } catch (e) {
      print(e);
    }
  }
}

class Program {
  String? programId;
  String? programCategoryId;
  String? name;
  String? programCategory;
  String? description;
  ProgramFeatures? features;
  List<ProgramActivity>? activities;

  Program();

  Map<String, dynamic> toMap() => {
    "programId": programId,
    "programCategoryId": programCategoryId,
    "name": name,
    "programCategory": programCategory,
    "description": description,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Program.fromMap(Map<String, dynamic> map) {
    try {
      this.programId = map["programId"].length > 0 ? map["programId"] : "1";
      this.programCategoryId = map["programCategoryId"] ?? "";
      this.name = map["name"] ?? "";
      this.programCategory = map["programCategory"] ?? "";
      this.features = map["features"] != null ? _setProgramFeatures(map["features"]) : ProgramFeatures();
      this.description = map["description"] ?? "";
    } catch (e) {
      print(e);
    }
  }

  ProgramFeatures _setProgramFeatures(Map<String, dynamic> features) {
    var programFeatured = ProgramFeatures.fromMap(features);

    return programFeatured;
  }
}

@injectable
class ProgramActivity {
  String? programId;
  String? programActivityId;
  String? title;
  String? trigger;
  String? triggerMeasure;
  int? triggerValue;
  String? startTrigger;
  String? startTriggerMeasure;
  int? startTriggerValue;
  String? delayedActivityMessage;
  String? type;
  String? description;
  DateTime? toBeExecutedOn;

  ProgramActivity();

  Map<String, dynamic> toMap() => {
    "programId": programId,
    "programActivityId": programActivityId,
    "title": title,
    "type": type,
    "description": description,
    "toBeExecutedOn": toBeExecutedOn,
    "createdOn": FieldValue.serverTimestamp(),
  };

  ProgramActivity.fromMap(Map<String, dynamic> map, String programId) {
    try {
      this.programId = programId;
      this.programActivityId = map["programActivityId"] ?? "";
      this.type = map["type"] ?? "";
      this.title = map["title"] ?? "";
      this.description = map["description"] ?? "";
      this.toBeExecutedOn = map["toBeExecutedOn"] != null ? map["toBeExecutedOn"].toDate() : null;
      this.trigger = map["trigger"] ?? "";
      this.triggerMeasure = map["triggerMeasure"] ?? "";
      this.triggerValue = map["triggerValue"] != null ? map["triggerValue"] : 0;
      this.startTrigger = map["startTrigger"] ?? "";
      this.startTriggerMeasure = map["startTriggerMeasure"] ?? "";
      this.startTriggerValue = map["startTriggerValue"] != null ? map["startTriggerValue"] : 0;
      this.delayedActivityMessage = map["delayedActivityMessage"] ?? "";
    } catch (e) {
      print(e);
    }
  }

  ProgramActivity copyWith() {
    ProgramActivity newProgramActivity = ProgramActivity();

    newProgramActivity.delayedActivityMessage = this.delayedActivityMessage;
    newProgramActivity.description = this.description;
    newProgramActivity.programActivityId = this.programActivityId;
    newProgramActivity.programId = this.programId;
    newProgramActivity.title = this.title;
    newProgramActivity.toBeExecutedOn = this.toBeExecutedOn;
    newProgramActivity.trigger = this.trigger;
    newProgramActivity.triggerMeasure = this.triggerMeasure;
    newProgramActivity.triggerValue = this.triggerValue;
    newProgramActivity.type = this.type;

    return newProgramActivity;
  }
}