import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:plushie_app/profile_page.dart';

class NfcReader extends StatefulWidget {
  const NfcReader({super.key});

  @override
  State<NfcReader> createState() => _NfcReaderState();
}

class _NfcReaderState extends State<NfcReader> {
  final StreamController<Map<String, dynamic>> _streamController = StreamController.broadcast();

  void process(NdefRecord record) {
    String payload = String.fromCharCodes(record.payload);
    _streamController.add(jsonDecode(payload));
  }

  @override
  void initState() {
    super.initState();
    _startNfcScanning();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession(); // Stop NFC when leaving
    super.dispose();
  }

  void _startNfcScanning() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // Extract NFC data
        Map<String, dynamic> nfcData = tag.data;

        // Stop session
        NfcManager.instance.stopSession();

        // Navigate to ProfilePage with NFC data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(nfcData: nfcData)),
        );
      },
    );
  }

  void startScan() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        if (ndef != null) {
          try {
            NdefMessage message = await ndef.read();
            for (var record in message.records) {
              process(record);
            }
          toast("A page will open shortly");
          } catch (e) {
            print(e);
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan NFC Tag")),
      body: Center(
        child: Text("Scan an NFC tag..."),
      ),
    );
  }
}

