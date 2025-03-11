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
              NfcReader.instance.process(String.fromCharCodes(record.payload));
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
        : ListView(
          children: [
                ValueListenableBuilder<dynamic>(
                  valueListenable: NfcReader.instance.processedPayloads,
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
          ],
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
