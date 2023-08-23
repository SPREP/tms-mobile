import 'dart:io';
import 'package:http/http.dart' as http;

class UploadFile {
  bool success = false;
  String message = '';

  bool isUploaded = false;

  Future<void> call(String url, File image) async {
    try {
      var response = await http.put(
        Uri.parse(url),
        body: image.readAsBytesSync(),
      );
      if (response.statusCode == 200) {
        isUploaded = true;
      }
    } catch (e) {
      throw ("Error uploading photo ${e.toString()}");
    }
  }
}
