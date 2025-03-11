import 'dart:async';
import 'dart:convert';

import 'package:nfc_manager/nfc_manager.dart';

class NfcReader {
  static NfcReader instance = NfcReader();
  final StreamController<Map<String, dynamic>> _streamController = StreamController.broadcast();

  Stream<Map<String, dynamic>> get processedPayloads => _streamController.stream;

  void process(NdefRecord record) {
    String payload = String.fromCharCodes(record.payload);
    _streamController.add(jsonDecode(payload));
  }
}
