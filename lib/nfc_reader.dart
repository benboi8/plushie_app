import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:overlay_support/overlay_support.dart';

import 'profile_page.dart';

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
        final ndef = Ndef.from(tag);
        if (ndef != null) {
          NdefMessage message = await ndef.read();

          Map<String, dynamic> nfcData = {};
          for (var record in message.records) {
            nfcData.addAll(jsonDecode(String.fromCharCodes(record.payload)));
          }

          // Stop session
          NfcManager.instance.stopSession();

          // Navigate to ProfilePage with NFC data
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(nfcData: nfcData)),
          );
        }
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
    return Center(
        child: Text("Scan an NFC tag..."),
    );
  }
}

