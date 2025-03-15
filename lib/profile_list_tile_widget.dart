import 'package:flutter/material.dart';
import 'package:plushie_app/profile_page.dart';

import 'profile_data.dart';
import 'style.dart';

class ProfileListTileWidget extends StatefulWidget {
  final ProfileData profileData;
  const ProfileListTileWidget({super.key, required this.profileData});

  @override
  State<ProfileListTileWidget> createState() => _ProfileListTileWidgetState();
}

class _ProfileListTileWidgetState extends State<ProfileListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(profileData: widget.profileData)));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(foregroundImage: NetworkImage(widget.profileData.url), radius: Style.profilePictureRadius / 2),
              Padding(padding: EdgeInsets.all(8.0)),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.profileData.name, style: TextStyle(fontSize: 30)),
                  Text("Origin: ${widget.profileData.origin}"),
                  Text("Gender: ${widget.profileData.gender}"),
                  Text("Color: ${widget.profileData.color}"),
                  Text("Personality Type: ${widget.profileData.personalityType}"),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}
