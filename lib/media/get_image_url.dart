import 'dart:convert';
import 'package:http/http.dart' as http;

class GetImageUrl {
  bool success = false;
  String message = '';

  bool isGenerated = false;
  String uploadUrl = '';
  String downloadUrl = '';

  Future<void> call(String fileType) async {
    try {
      Map body = {"fileType": fileType};
      var response = await http.post(
        Uri.parse('http://app.met.gov.to:5000/generatePresignedUrl'),
        headers: <String, String>{},
        body: body,
      );

      var result = jsonDecode(response.body);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if (response.statusCode == 201) {
          isGenerated = true;
          uploadUrl = result['uploadUrl'];
          downloadUrl = result['downloadUrl'];
        }
      }
    } catch (e) {
      throw ("Error getting url ${e.toString()}");
    }
  }
}
