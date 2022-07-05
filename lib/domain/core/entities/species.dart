import 'package:injectable/injectable.dart';

@injectable
class Species {
  String? name;

  Species(this.name);

  Species.fromJson(String name) {
    try {
      this.name = name;
    } catch (e) {
      print(e);
    }
  }
}