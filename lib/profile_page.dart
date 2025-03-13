import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:plushie_app/style.dart';

import 'nfc_reader.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NfcManager.instance.isAvailable(),
      builder:
          (context, ss) =>
              ss.data != true
                  ? Center(child: Text("NfcManager.isAvailable(): ${ss.data}"))
                  : StreamBuilder<Map<String, dynamic>>(
                    stream: NfcReader.instance.processedPayloads,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text("Waiting for NFC...");

                      var keys = snapshot.data!.keys;
                      var values = snapshot.data!.values;

                      // TODO: Finish Profile Page

                      for (String key in keys) {
                        if (key == "profilePictureUrl") {
                              return CircleAvatar(
                                radius: Style.profilePictureRadius,
                                backgroundImage: NetworkImage(
                                    values.elementAt(keys.toList().indexOf(key))
                                )
                              );
                        }
                      }

                      return ListView.builder(
                        itemBuilder: (context, index) {
                          if (index >= snapshot.data!.length) {
                            return null;
                          }
                          var keys = snapshot.data!.keys;
                          var values = snapshot.data!.values;

                          // profile picture
                          if (keys.elementAt(index) == "profilePictureUrl") {
                            return CircleAvatar(
                                radius: Style.profilePictureRadius,
                                backgroundImage: NetworkImage(
                                    values.elementAtOrNull(index)
                                )

                              );
                          }

                          String title =
                              keys
                                  .elementAtOrNull(index)
                                  ?.replaceRange(
                                    0,
                                    1,
                                    keys
                                        .elementAtOrNull(index)![0]
                                        .toUpperCase(),
                                  )
                                  .replaceAll("_", " ") ??
                              "";

                          if (keys
                              .elementAt(index)
                              .toLowerCase()
                              .contains("url")) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                  title,
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    values.elementAt(index),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Text("Image not found"),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Card(
                            child: ListTile(
                              title: Text(
                                title,
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: Text(
                                values
                                        .elementAtOrNull(index)
                                        ?.replaceRange(
                                          0,
                                          1,
                                          values
                                              .elementAtOrNull(index)![0]
                                              .toUpperCase(),
                                        ) ??
                                    "",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
    );
  }
}
