import 'package:injectable/injectable.dart';

@injectable
class NotificationModel {
  String? notificationId;
  String? title;
  String? type;
  String? description;
  bool? viewed;

  NotificationModel();

  NotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      this.notificationId = map["notificationId"] ?? "";
      this.title = map["title"] ?? "";
      this.type = map["type"] ?? "";
      this.description = map["description"] ?? "";
      this.viewed = map["viewed"] ?? false;
    } catch (e) {
      print(e);
    }
  }
}