import 'dart:convert';

import 'package:http/http.dart' as http;

class DatabaseManager {
  final String baseUrl = 'http://192.168.7.127:8000';

  Future<List<Map<String, dynamic>>> sendRequest(Uri url) async {
    List<Map<String, dynamic>> data = [];

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    return data;
  }

  Future<List<Map<String, dynamic>>> fetchPlushData() async => await sendRequest(Uri.parse("$baseUrl/plush"));
  
  Future<List<Map<String, dynamic>>> fetchLatestId() async => await sendRequest(Uri.parse("$baseUrl/id")).then((value) => value);

  Future<List<Map<String, dynamic>>> getPlaceholder() async => await sendRequest(Uri.parse("$baseUrl/placeholder")).then((value) => value);

  Future<Map<String, List<Map<String, dynamic>>>> fetchEditingConstraints() async {
    final url = "$baseUrl/constraints";

    final originUrl = Uri.parse("$url/origin");
    final genderUrl = Uri.parse("$url/gender");
    final personalityUrl = Uri.parse("$url/personality");
    final colorUrl = Uri.parse("$url/color");

    Map<String, List<Map<String, dynamic>>> data = {};

    await sendRequest(originUrl).then((value) => data["origin"] = value);
    await sendRequest(genderUrl).then((value) => data["gender"] = value);
    await sendRequest(personalityUrl).then((value) => data["personality_type"] = value);
    await sendRequest(colorUrl).then((value) => data["color"] = value);

    return data;
  }
}