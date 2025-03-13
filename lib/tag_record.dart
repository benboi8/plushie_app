class TagRecord {
  static String? name;
  static String? profilePictureUrl;
  static String? origin;
  static String? gender;
  static String? color;
  static String? personalityType;

  static void reset() {
    name = null;
    profilePictureUrl = null;
    origin = null;
    gender = null;
    color = null;
    personalityType = null;
  }

  static String get json => '{"name": "$name", "profilePictureUrl": "$profilePictureUrl", "origin": "$origin", "gender": "$gender", "color": "$color", "personality_type": "$personalityType"}';
}