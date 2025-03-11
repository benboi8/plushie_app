import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'tag_record.dart';

class NfcWriterWidget extends StatefulWidget {
  const NfcWriterWidget({super.key});

  @override
  State<NfcWriterWidget> createState() => _NfcWriterWidgetState();
}

class _NfcWriterWidgetState extends State<NfcWriterWidget> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  String name = "default";
  String origin = "default";
  String gender = "default";
  String color = "default";
  String personalityType = "default";

  bool isDialogOpen = false;

  void write(BuildContext context) {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);

        isDialogOpen = false;
        Navigator.of(context).pop();

        if (ndef == null || !ndef.isWritable) {
          result.value = 'Tag is not ndef writable';
          NfcManager.instance.stopSession(errorMessage: result.value);
          return;
        }

        TagRecord tagRecord = TagRecord(name, origin, gender, color, personalityType);
        NdefMessage message = NdefMessage([
          NdefRecord.createExternal(
              "com.example.plushie_app",
              "launch",
              Uint8List.fromList(tagRecord.json.codeUnits)),
        ]);

        try {
          await ndef.write(message);
          result.value = 'Success writing new tag';
          NfcManager.instance.stopSession();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } catch (e) {
          result.value = "Failed to write new tag. Please try again";
          debugPrint(e.toString());
          NfcManager.instance.stopSession(errorMessage: result.value.toString());
          return;
        }
    });
  }

  void showWriteAlertDialog(BuildContext context) {
    isDialogOpen = true;
    showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) {
          return AlertDialog(
            title: Text("Scan NFC Tag"),
            content: Text("Scan the NFC Tag you want to associate with this data."),
            actions: [
              TextButton(
                  onPressed: () {
                    isDialogOpen = false;
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")
              )
            ],
          );
        }
    );

    write(context);
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Writer"),
      ),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
            ? Center(child: Text("NfcManager.isAvailable(): ${ss.data}"))
            : ListView(
              children: [
                ValueListenableBuilder<dynamic>(
                  valueListenable: result,
                  builder: (context, value, _) =>
                    Center(
                      child: SizedBox(
                        width: double.infinity, // Makes it take the full row width
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('${value ?? ''}', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                ),

                // Name
                ListTile(
                  title: Text("Name:"),
                ),
                TextFormField(
                  onChanged: (newValue) {
                    setState(() {
                      name = newValue;
                    });
                  },
                ),

                // Origin
                ListTile(
                  title: Text("Origin:"),
                ),
                TextFormField(
                  onChanged: (newValue) {
                    setState(() {
                      origin = newValue;
                    });
                  },
                ),

                // Gender
                ListTile(
                  title: Text("Gender:"),
                ),
                TextFormField(
                  onChanged: (newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                ),

                // Color
                ListTile(
                  title: Text("Color:"),
                ),
                TextFormField(
                  onChanged: (newValue) {
                    setState(() {
                      color = newValue;
                    });
                  },
                ),

                // Personality Type
                ListTile(
                  title: Text("Personality Type:"),
                ),
                TextFormField(
                  onChanged: (newValue) {
                    setState(() {
                      personalityType = newValue;
                    });
                  },
                ),

                // Submit
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showWriteAlertDialog(context);
                      });
                    },
                    child: Text("Submit")
                )
              ],
            ),
        ),
      )
    );
  }
}