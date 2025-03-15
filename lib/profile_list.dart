import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plushie_app/profile_list_tile_widget.dart';
import 'package:plushie_app/style.dart';

import 'profile_data.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  List<Map<String, dynamic>> _plushList = [];
  bool _isLoading = true;

  @override
  void initState() {
    fetchPlushData();
    super.initState();
  }

  Future<void> fetchPlushData() async {
    final url = Uri.parse('http://192.168.7.127:8000/plush');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _plushList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          _isLoading = false;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of all plushies"),
        actions: appBarActions(context),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _plushList.length,
              itemBuilder: (context, index) {
                final plush = _plushList[index];

                print(plush);

                final origin = plush["origin"][0];
                final gender = plush["gender"][0];
                final color = plush["color"][0];
                final personalityType = plush["personality_type"][0]["type"];
                final url = plush["profile_picture_url"][0]["uri"];

                ProfileData profileData = ProfileData(name: plush["name"], url: url, origin: origin["name"], gender: gender["name"], color: color["name"], personalityType: personalityType, geoData: [origin["latitude"], origin["longitude"]]);
                return ProfileListTileWidget(profileData: profileData);
              },
            ),
    );
  }
}
