import 'package:flutter/material.dart';
import 'package:plushie_app/style.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> nfcData;
  const ProfilePage({super.key, required this.nfcData});

  Map<String, dynamic> _processNfcData(Map<String, dynamic> data) {
    // TODO: Change data to be the payload like how it is done in nfc_reader, by reading the ndef tag and processing the messages

    Map<String, dynamic> processedData = {};

    data.forEach((key, value) {
      print(key.runtimeType);
      print(value.runtimeType);
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

  Future<void> _openGoogleMaps() async {
    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> processedData = widget._processNfcData(widget.nfcData);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(processedData["name"], textAlign: TextAlign.center)
      ),
      body: ListView(
        children: [
          CircleAvatar(
            radius: Style.profilePictureRadius,
            backgroundImage: NetworkImage(processedData["profilePictureUrl"]),
          ),
          ListTile(
            title: Text("Origin", style: TextStyle(fontSize: 20)),
            trailing: TextButton(
                onPressed: () => _openGoogleMaps(),
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
