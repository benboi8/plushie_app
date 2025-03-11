class TagRecord {
  late String name;
  late String origin;
  late String gender;
  late String color;
  late String personalityType;

  TagRecord(this.name, this.origin, this.gender, this.color, this.personalityType);

  String get json => '{"name": $name, "origin": $origin, "gender": $gender, "color": $color, "personality_type": $personalityType}';
}