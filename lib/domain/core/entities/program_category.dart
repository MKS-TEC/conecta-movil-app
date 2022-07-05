class ProgramCategory {
  late String id;
  late String name;
  late String icon;
  late String description;
  late int level;
  late int index;

  ProgramCategory(
    this.id,
    this.name,
    this.icon,
    this.description,
    this.level,
    this.index,
  );

  ProgramCategory.fromMap(Map<String, dynamic> map) {
    this.id = map["programCategoryId"] ?? "";
    this.name = map["name"] ?? "";
    this.icon = map["icon"] ?? "";
    this.description = map["description"] ?? "";
    this.level = map["level"] ?? 0;
    this.index = map["index"] ?? 0;
  }
}