import 'package:flutter/material.dart';
import 'package:plushie_app/database_manager.dart';

class Origin {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  Origin({required this.id, required this.name, required this.latitude, required this.longitude});
}

class Gender {
  final int id;
  final String name;
  final String symbol;

  Gender({required this.id, required this.name, required this.symbol});
}

class CustomColor {
  final int id;
  final String name;
  final Color value;

  CustomColor({required this.id, required this.name, required this.value});
}

class PersonalityType {
  final int id;
  final String name;
  final String description;

  PersonalityType({required this.id, required this.name, required this.description});
}

class ProfileData {
  final String id;
  final String name;
  final String url;
  final Origin origin;
  final Gender gender;
  final CustomColor color;
  final PersonalityType personalityType;

  factory ProfileData.empty(var data) {
    print("DATA: $data");

    return ProfileData(
        id: data.toString(),
        name: "name",
        url: "url",
        origin: Origin(id: 1000, name: "name", latitude: 0, longitude: 0),
        gender: Gender(id: 1000, name: "name", symbol: "symbol"),
        color: CustomColor(id: 1000, name: "name", value: Color(0x00000000)),
        personalityType: PersonalityType(id: 1000, name: "name", description: "description"),
    );
  }

  ProfileData({
    required this.id,
    required this.name,
    required this.url,
    required this.origin,
    required this.gender,
    required this.color,
    required this.personalityType,
  });

  factory ProfileData.fromDatabase(var data) {
    final origin = data["origin"][0];
    final gender = data["gender"][0];
    final color = data["color"][0];
    final personalityType = data["personality_type"][0];

    return ProfileData(
        id: data["id"].toString(),
        name: data["name"],
        url: data["profile_picture_url"][0]["uri"],
        origin: Origin(id: origin["id"], name: origin["name"], latitude: origin["latitude"], longitude: origin["longitude"]),
        gender: Gender(id: gender["id"], name: gender["name"], symbol: gender["symbol"]),
        color: CustomColor(id: color["id"], name: color["name"], value: Color(int.parse(color["hex_code"]))),
        personalityType: PersonalityType(id: personalityType["id"], name: personalityType["name"], description: personalityType["description"]),
    );
  }

  factory ProfileData.fromNfcData(var nfcData) {
    // TODO make this a database query that returns .fromDatabase factory
    Map<String, dynamic> processedData = {};

    nfcData.forEach((key, value) {
      processedData[key] = value;
    });

    print(processedData.toString());

    return ProfileData(
      id: processedData["id"],
      name: processedData["name"],
      url: processedData["profile_picture_url"]["uri"],
      origin: processedData["origin"]["name"],
      gender: processedData["gender"]["name"],
      color: processedData["color"]["name"],
      personalityType: processedData["personalityType"]["type"],
    );
  }
}
