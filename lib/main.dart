import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:plushie_app/profile_data.dart';

import 'database_manager.dart';
import 'nfc_reader.dart';
import 'nfc_writer_widget.dart';

import 'style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
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
        actions: appBarActions(context)
      ),
      body: NfcReader(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          int data;

          DatabaseManager().getPlaceholder().then((value) {
            data = value[0]["id"] + 1;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NfcWriterWidget(data: ProfileData.empty(data))),
            );
          });
        },
      ),
    );
  }
}
