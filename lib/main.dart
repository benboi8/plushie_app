import 'package:flutter/material.dart';
import 'package:plushie_app/nfc_reader.dart';

void main() {
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
      appBar: AppBar(),
      body: NfcReader(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            //  Make a new record to write to NFC tag
            //  navigate to new page to fill in details then confirm and write to tag
          }
      ),
    );
  }
}
