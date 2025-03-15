import 'package:flutter/material.dart';

import 'profile_list.dart';
import 'wish_list.dart';


List<Widget> appBarActions(context) => [
IconButton(
  icon: Icon(Icons.favorite, color: Colors.red),
  onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WishList()));
  }),
IconButton(
  icon: Icon(Icons.list, color: Colors.black),
  onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileList()));
  },
)];

class Style {
  static final double profilePictureRadius = 128;
}