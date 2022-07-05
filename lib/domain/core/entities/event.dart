
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class EventFeatured {
  String? eventCategory;
  String? species;
  String? breed;

  EventFeatured();

  EventFeatured.fromMap(Map<String, dynamic> map) {
    try {
      this.eventCategory = map["eventCategory"] ?? "";
      this.species = map["species"] ?? "";
      this.breed = map["breed"] ?? "";
    } catch (e) {
      print(e);
    }
  }
}

@injectable
class Event {
  String? eventId;
  String? title;
  String? location;
  DateTime? createdOn;
  String? imageUrl;
  DateTime? date;
  bool? isPrivate;
  EventFeatured? features;
  String? description;
  List<String>? tags;

  Event();

  Map<String, dynamic> toMap() => {
    "eventId": eventId,
    "title": title,
    "imageUrl": imageUrl,
    "date": date,
    "location": location,
    "isPrivate": isPrivate,
    "description": description,
    "tags": tags,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Event.fromMap(Map<String, dynamic> map) {
    try {
      this.eventId = map["eventId"] ?? "";
      this.title = map["title"] ?? "";
      this.location = map["location"] ?? "";
      this.imageUrl = map["imageUrl"] ?? "";
      this.isPrivate = map["isPrivate"] != null ? map["isPrivate"] : false;
      this.description = map["description"] ?? "";
      this.features = map["features"] != null ? _setEventFeatures(map["features"]) : EventFeatured();
      this.tags = map["tags"] != null ? map["tags"] : List<String>.empty(growable: true);
      this.date = map["date"] != null ? map["date"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }

  EventFeatured _setEventFeatures(Map<String, dynamic> features) {
    var eventFeatured = EventFeatured.fromMap(features);

    return eventFeatured;
  }
}