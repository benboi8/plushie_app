import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'tag_record.dart';

class NfcWriter extends StatefulWidget {
  const NfcWriter({super.key});

  @override
  State<NfcWriter> createState() => _NfcWriterState();
}

class _NfcWriterState extends State<NfcWriter> {
  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  TagRecord tagRecord = TagRecord();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Writer"),
      ),
      body: ListView(
        children: [
          // Name
          ListTile(
            title: Text("Name:"),
          ),
          TextFormField(
            onSaved: (newValue) {
              setState(() {
                tagRecord.name = newValue!;
              });
            },
          ),

          // Origin
          ListTile(
            title: Text("Origin:"),
          ),
          TextFormField(
            onSaved: (newValue) {
              setState(() {
                tagRecord.origin = newValue!;
              });
            },
          ),

          // Gender
          ListTile(
            title: Text("Gender:"),
          ),
          TextFormField(
            onSaved: (newValue) {
              setState(() {
                tagRecord.gender = newValue!;
              });
            },
          ),

          // Color
          ListTile(
            title: Text("Color:"),
          ),
          TextFormField(
            onSaved: (newValue) {
              setState(() {
                tagRecord.color = newValue!;
              });
            },
          ),

          // Personality Type
          ListTile(
            title: Text("Personality Type:"),
          ),
          TextFormField(
            onSaved: (newValue) {
              setState(() {
                tagRecord.personalityType = newValue!;
              });
            },
          )
        ],
      )
    );
  }
}