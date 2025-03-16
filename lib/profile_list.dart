import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plushie_app/database_manager.dart';
import 'package:plushie_app/profile_list_tile_widget.dart';
import 'package:plushie_app/style.dart';

import 'profile_data.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  List<Map<String, dynamic>> plushList = [];
  bool isLoading = true;

  @override
  void initState() {
    DatabaseManager().fetchPlushData().then((value) {
      setState(() {
        isLoading = false;
        plushList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of all plushies"),
        actions: appBarActions(context),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: plushList.length,
              itemBuilder: (context, index) {
                final plush = plushList[index];

                ProfileData profileData = ProfileData.fromDatabase(plush);
                return ProfileListTileWidget(profileData: profileData);
              },
            ),
    );
  }
}
