import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcReader extends StatefulWidget {
  const NfcReader({super.key});

  @override
  State<NfcReader> createState() => _NfcReaderState();
}

class _NfcReaderState extends State<NfcReader> {
  _NfcReaderState() {
    setup();
  }

  String message = "";

  void setup() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      setState(() {
        message = "NFC can not be used.";
      });
      return null;
    }

    // Start Session
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // Do something with an NfcTag instance.
        Ndef? ndef = Ndef.from(tag);

        if (ndef == null) {
          setState(() {
            message = 'Tag is not compatible with NDEF';
          });
          return;
        }

        List<String> payloads = [];

        for (NdefRecord record in ndef.cachedMessage!.records) {
          payloads.add(utf8.decode(record.payload));
          // todo: process data
        }

        setState(() {
          message = payloads.toString();
        });
      }
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(message),
    );
  }
}