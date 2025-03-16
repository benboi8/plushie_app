import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:plushie_app/database_manager.dart';
import 'profile_data.dart';
import 'tag_record.dart';

import 'image_picker_page.dart';
import 'style.dart';

class NfcWriterWidget extends StatefulWidget {
  final ProfileData data;
  const NfcWriterWidget({super.key, required this.data});

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
          NfcManager.instance.stopSession(
            errorMessage: 'Tag is not ndef writable',
          );
          return;
        }

        NdefMessage message = NdefMessage([
          NdefRecord.createExternal(
            "com.example.plushie_app",
            "launch",
            Uint8List.fromList(widget.data.id.codeUnits),
          ),
        ]);

        try {
          await ndef.write(message);
          NfcManager.instance.stopSession();
          if (context.mounted) {
            Navigator.of(context).pop();
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

  String selectedOrigin = "";
  String selectedGender = "";
  String selectedColor = "";
  String selectedPersonalityType = "";

  @override
  void initState() {
    super.initState();

    getAllowedData();
    selectedOrigin = widget.data.origin.name;
    selectedGender = widget.data.gender.name;
    selectedColor = widget.data.color.name;
    selectedPersonalityType = widget.data.personalityType.name;
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  List<Map<String, dynamic>> originConstraints = [];
  List<Map<String, dynamic>> genderConstraints = [];
  List<Map<String, dynamic>> colorConstraints = [];
  List<Map<String, dynamic>> personalityTypeConstraints = [];

  void getAllowedData() {
    DatabaseManager().fetchEditingConstraints().then((value) {
      originConstraints = value["origin"]!;
      genderConstraints = value["gender"]!;
      colorConstraints = value["color"]!;
      personalityTypeConstraints = value["personality_type"]!;
    });
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Writer"), actions: appBarActions(context)),
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
                                      initialValue: widget.data.name,
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

                          // Profile picture
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Profile Picture:"),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const ImagePickerPage(),
                                          ),
                                        );
                                      },
                                      icon: CircleAvatar(
                                        radius: Style.profilePictureRadius,
                                        foregroundImage: NetworkImage(
                                          widget.data.url,
                                        ),
                                      ),
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
                                  trailing: DropdownButton(
                                    value: selectedOrigin,
                                    items:
                                        originConstraints
                                            .map(
                                              (Map<String, dynamic> item) =>
                                                  DropdownMenuItem(
                                                    value: item["name"],
                                                    child: Text(item["name"]),
                                                  ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOrigin = value.toString();
                                      });
                                    },
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
                                  trailing: DropdownButton(
                                    value: selectedGender,
                                    items:
                                        genderConstraints
                                            .map(
                                              (Map<String, dynamic> item) =>
                                                  DropdownMenuItem(
                                                    value: item["name"],
                                                    child: Text(item["name"]),
                                                  ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value.toString();
                                      });
                                    },
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
                                  title: Text("Colors:"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: const Text(
                                                    'Pick a color!',
                                                  ),
                                                  content: SingleChildScrollView(
                                                    child: ColorPicker(
                                                      pickerColor: pickerColor,
                                                      onColorChanged: changeColor,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child: const Text('Select'),
                                                      onPressed: () {
                                                        setState(
                                                          () =>
                                                              currentColor =
                                                                  pickerColor,
                                                        );
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                        icon: Icon(Icons.color_lens),
                                      ),
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: ColoredBox(color: currentColor, child: Text(""),))
                                    ],
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
                                  trailing: DropdownButton(
                                    value: selectedPersonalityType,
                                    items:
                                        personalityTypeConstraints
                                            .map(
                                              (Map<String, dynamic> item) =>
                                                  DropdownMenuItem(
                                                    value: item["name"],
                                                    child: Text(item["name"]),
                                                  ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPersonalityType =
                                            value.toString();
                                      });
                                    },
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
