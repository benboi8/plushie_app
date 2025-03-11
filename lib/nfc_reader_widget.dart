import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'nfc_reader.dart';

class NfcReaderWidget extends StatefulWidget {
  const NfcReaderWidget({super.key});

  @override
  State<NfcReaderWidget> createState() => _NfcReaderWidgetState();
}

class _NfcReaderWidgetState extends State<NfcReaderWidget> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  bool isDialogOpen = false;

  void showWriteAlertDialog(BuildContext context) {
    isDialogOpen = true;
    showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) {
          return AlertDialog(
            title: Text("Scan NFC Tag"),
            content: Text("Scan the NFC Tag you want to read."),
            actions: [
              TextButton(
                  onPressed: () {
                    isDialogOpen = false;
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")
              )
            ],
          );
        }
    );

    read(context);
  }

  void read(BuildContext context) {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);

        isDialogOpen = false;
        Navigator.of(context).pop();

        if (ndef == null) {
          String errorMessage = 'Tag is not compatible with NDEF';
          result.value = errorMessage;
          NfcManager.instance.stopSession(errorMessage: errorMessage);
          return;
        }

        for (NdefRecord record in ndef.cachedMessage!.records) {
          NfcReader.instance.process(String.fromCharCodes(record.payload));
        }

        NfcManager.instance.stopSession();
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
    return SafeArea(
      child: FutureBuilder(
        future: NfcManager.instance.isAvailable(),
        builder: (context, ss) => ss.data != true
        ? Center(child: Text("NfcManager.isAvailable(): ${ss.data}"))
        : ListView(
          children: [
            // Center(
            //   child: Text(NfcReader.instance.processedPayloads),
            // )
          ],
        ),
        )
    );
  }
}