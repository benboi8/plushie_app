import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'nfc_reader.dart';
import 'nfc_writer_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  // If the app was launched via NFC, process the tag
  if (Platform.isAndroid) {
    NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          final ndef = Ndef.from(tag);
          if (ndef != null) {
            NdefMessage message = await ndef.read();
            for (var record in message.records) {
              NfcReader.instance.process(record);
            }
            NfcManager.instance.stopSession();
          }
        }
    );
  }
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
                return Card(
                  child: ListTile(
                    title: Text(
                        snapshot.data?.keys.elementAtOrNull(index)
                            ?.replaceRange(0, 1, snapshot.data!.keys.elementAtOrNull(index)![0].toUpperCase())
                            .replaceAll("_", " ")
                            ?? "",
                        style: TextStyle(fontSize: 20)),
                    trailing: Text(
                        snapshot.data?.values.elementAtOrNull(index)
                            ?.replaceRange(0, 1, snapshot.data!.values.elementAtOrNull(index)![0].toUpperCase())
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
