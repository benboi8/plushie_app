import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'nfc_writer_widget.dart';
import 'profile_data.dart';
import 'style.dart';

class ProfilePage extends StatefulWidget {
  final ProfileData profileData;
  const ProfilePage({super.key, required this.profileData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    final double latitude = 52.2066983;
    final double longitude = -4.3470603;

  Future<void> _openGoogleMaps(latitude, longitude) async {
    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    await launchUrl(googleMapsUri);
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.profileData.name, textAlign: TextAlign.center),
        actions: appBarActions(context),
      ),
      body: ListView(
        children: [
          CircleAvatar(
            radius: Style.profilePictureRadius,
            foregroundImage: NetworkImage(widget.profileData.url),
            child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
          ),
          ListTile(
            title: Text("Origin", style: TextStyle(fontSize: 20)),
            trailing: TextButton(
                onPressed: () => _openGoogleMaps(widget.profileData.origin.latitude, widget.profileData.origin.longitude),
                child: Text(widget.profileData.origin.name, style: TextStyle(fontSize: 20))
            ),
          ),
          ListTile(
            title: Text("Gender", style: TextStyle(fontSize: 20)),
            trailing: Text(widget.profileData.gender.name, style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            title: Text("Color", style: TextStyle(fontSize: 20)),
            trailing: Text(widget.profileData.color.name, style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            title: Text("Personality Type", style: TextStyle(fontSize: 20)),
            trailing: Text(widget.profileData.personalityType.name, style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NfcWriterWidget(data: widget.profileData)),
          );
        },
      ),
    );
  }
}
