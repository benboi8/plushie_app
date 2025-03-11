class TagRecord {
  static late String _name;

  static set name(String value) {
    _name = value;
  }

  static late Uri _profilePictureUrl;

  static set profilePictureUrl(String value) {
    _profilePictureUrl = _profilePictureUrl = Uri(
      scheme: "https",
      host: "192.168.7.127",
      path: value
    );
  }

  static late String _origin;

  static set origin(String value) {
    _origin = value;
  }

  static late String _gender;

  static set gender(String value) {
    _gender = value;
  }

  static late String _color;

  static set color(String value) {
    _color = value;
  }

  static late String _personalityType;

  static set personalityType(String value) {
    _personalityType = value;
  }

  static String get json => '{"name": "$_name", "profilePictureUrl": "$_profilePictureUrl", "origin": "$_origin", "gender": "$_gender", "color": "$_color", "personality_type": "$_personalityType"}';
}