import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plushie_app/tag_record.dart';

class WebManager {
  final serverUrl = "http://192.168.7.127/uploads/upload.php";

  Future<void> uploadImage(XFile image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(serverUrl)
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);

      var uploadedUrl = jsonDecode(res.body)["url"];

      TagRecord.profilePictureUrl = uploadedUrl;

      if (kDebugMode) {
        print("Upload Success: $uploadedUrl");
      }
    } else {
      if (kDebugMode) {
        print("Upload Failed");
      }
    }
  }
}