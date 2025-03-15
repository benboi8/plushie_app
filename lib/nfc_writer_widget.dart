import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'tag_record.dart';

import 'image_picker_page.dart';
import 'style.dart';

class NfcWriterWidget extends StatefulWidget {
  const NfcWriterWidget({super.key});

  @override
  State<NfcWriterWidget> createState() => _NfcWriterWidgetState();
}

class _NfcWriterWidgetState extends State<NfcWriterWidget> {

  bool isDialogOpen = false;

  void write(BuildContext context) {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);

        isDialogOpen = false;
        Navigator.of(context).pop();

        if (ndef == null || !ndef.isWritable) {
          NfcManager.instance.stopSession(errorMessage: 'Tag is not ndef writable');
          return;
        }

        NdefMessage message = NdefMessage([
          NdefRecord.createExternal(
            "com.example.plushie_app",
            "launch",
            Uint8List.fromList(TagRecord.json.codeUnits),
          ),
        ]);

        try {
          await ndef.write(message);
          NfcManager.instance.stopSession();
          if (context.mounted) {
            Navigator.of(context).pop();
            TagRecord.reset();
          }
        } catch (e) {
          debugPrint(e.toString());
          NfcManager.instance.stopSession(
            errorMessage: "Failed to write new tag. Please try again",
          );

          return;
        }
      },
    );
  }

  void showWriteAlertDialog(BuildContext context) {
    isDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return AlertDialog(
          title: Text("Scan NFC Tag"),
          content: Text(
            "Scan the NFC Tag you want to associate with this data.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                isDialogOpen = false;
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
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
        actions: appBarActions(context),
      ),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder:
              (context, ss) =>
                  ss.data != true
                      ? Center(
                        child: Text("NfcManager.isAvailable(): ${ss.data}"),
                      )
                      : ListView(
                        children: [
                          // Name
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Name:"),
                                  trailing: SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      onChanged: (newValue) {
                                        setState(() {
                                          TagRecord.name = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Profile Picture:"),
                                  trailing: SizedBox(
                                    width: 200,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => const ImagePickerPage()),
                                          );
                                        },
                                        // TODO: Replace with Avatar
                                        child: TagRecord.profilePictureUrl == null ? Text("Pick Image") : Image.network(TagRecord.profilePictureUrl ?? "")
                                    ),
                                    // child: ImagePickerWidget()
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Origin
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Origin:"),
                                  trailing: SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      onChanged: (newValue) {
                                        setState(() {
                                          TagRecord.origin = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Gender
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Gender:"),
                                  trailing: SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      onChanged: (newValue) {
                                        setState(() {
                                          TagRecord.gender = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Color
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Color:"),
                                  trailing: SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      onChanged: (newValue) {
                                        setState(() {
                                          TagRecord.color = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Personality Type
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Personality Type:"),
                                  trailing: SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      onChanged: (newValue) {
                                        setState(() {
                                          TagRecord.personalityType = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Submit
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showWriteAlertDialog(context);
                                });
                              },
                              child: Text("Submit"),
                            ),
                          ),
                        ],
                      ),
        ),
      ),
    );
  }
}
