import 'package:flutter/material.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile();
      },
    );
  }
}
