import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'style.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> nfcData;
  const ProfilePage({super.key, required this.nfcData});

  Map<String, dynamic> _processNfcData(Map<String, dynamic> data) {
    Map<String, dynamic> processedData = {};

    data.forEach((key, value) {
      processedData[key] = value;
    });

    return processedData;
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    final double latitude = 52.2066983;
    final double longitude = -4.3470603;


  Future<void> _openGoogleMaps(geoData) async {
    geoData = [latitude, longitude];

    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    await launchUrl(googleMapsUri);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> processedData = widget._processNfcData(widget.nfcData);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(processedData["name"], textAlign: TextAlign.center),
        actions: appBarActions(context),
      ),
      body: ListView(
        children: [
          CircleAvatar(
            radius: Style.profilePictureRadius,
            foregroundImage: NetworkImage(processedData["profilePictureUrl"]),
            child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
          ),
          ListTile(
            title: Text("Origin", style: TextStyle(fontSize: 20)),
            trailing: TextButton(
                onPressed: () => _openGoogleMaps(processedData["geoData"]),
                child: Text(processedData["origin"], style: TextStyle(fontSize: 20))
            ),
          ),
          ListTile(
            title: Text("Gender", style: TextStyle(fontSize: 20)),
            trailing: Text(processedData["gender"], style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            title: Text("Color", style: TextStyle(fontSize: 20)),
            trailing: Text(processedData["color"], style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            title: Text("Personality Type", style: TextStyle(fontSize: 20)),
            trailing: Text(processedData["personality_type"], style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
