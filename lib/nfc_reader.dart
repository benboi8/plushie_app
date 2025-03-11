import 'package:flutter/cupertino.dart';

class NfcReader {
  static NfcReader instance = NfcReader();
  ValueNotifier<String> _processedPayloads = ValueNotifier("");

  void process(String payload) {
    _processedPayloads = ValueNotifier(_processedPayloads.value + payload);
  }

  ValueNotifier<String> get processedPayloads => _processedPayloads;
}