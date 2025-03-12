import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'nfc_reader.dart';
import 'nfc_writer_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // If the app was launched via NFC, process the tag
  if (Platform.isAndroid) {
    NfcReader.instance.startScan();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: FutureBuilder(
        future: NfcManager.instance.isAvailable(),
        builder: (context, ss) => ss.data != true
        ? Center(child: Text("NfcManager.isAvailable(): ${ss.data}"))
        : StreamBuilder<Map<String, dynamic>>(
          stream: NfcReader.instance.processedPayloads,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Waiting for NFC...");
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index >= snapshot.data!.length) {
                  return null;
                }
                var keys = snapshot.data!.keys;
                var values = snapshot.data!.values;

                String title = keys.elementAtOrNull(index)
                            ?.replaceRange(0, 1, keys.elementAtOrNull(index)![0].toUpperCase())
                            .replaceAll("_", " ")
                            ?? "";

                if (keys.elementAt(index).toLowerCase().contains("url")) {
                  print(values.elementAt(index));
                  return Card(
                    child: ListTile(
                      title: Text(title, style: TextStyle(fontSize: 20)),
                      trailing: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          values.elementAt(index),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Text("Image not found"),
                        ),
                      ),
                    ),
                  );
                }

                return Card(
                  child: ListTile(
                    title: Text(title, style: TextStyle(fontSize: 20)),
                    trailing: Text(
                        values.elementAtOrNull(index)
                            ?.replaceRange(0, 1, values.elementAtOrNull(index)![0].toUpperCase())
                            ?? "", style: TextStyle(fontSize: 20))
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NfcWriterWidget()),
          );
        }
      ),
    );
  }
}
