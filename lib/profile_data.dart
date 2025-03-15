class ProfileData {
  final String name;
  final String url;
  final String origin;
  final String gender;
  final String color;
  final String personalityType;
  final List<double> geoData;

  ProfileData({
    required this.name,
    required this.url,
    required this.origin,
    required this.gender,
    required this.color,
    required this.personalityType,
    required this.geoData,
  });

  factory ProfileData.fromNfcData(var nfcData) {
    Map<String, dynamic> processedData = {};

    nfcData.forEach((key, value) {
      processedData[key] = value;
    });
    return ProfileData(
      name: processedData["name"],
      url: processedData["profile_picture_url"]["uri"],
      origin: processedData["origin"]["name"],
      gender: processedData["gender"]["name"],
      color: processedData["color"]["name"],
      personalityType: processedData["personalityType"]["type"],
      geoData: [processedData["origin"]["latitude"], processedData["origin"]["longitude"]]
    );
  }
}