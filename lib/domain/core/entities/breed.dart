import 'package:injectable/injectable.dart';

@injectable
class Breed {
  String? name;

  Breed(this.name);

  Breed.fromJson(String name) {
    try {
      this.name = name;
    } catch (e) {
      print(e);
    }
  }
}