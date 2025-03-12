import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

    String? uploadedImageUrl;

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);

      uploadedImageUrl = res.body.contains("http") ? res.body : null;

      print("Upload Success: $uploadedImageUrl");
    } else {
      print("Upload Failed");
    }
  }
}