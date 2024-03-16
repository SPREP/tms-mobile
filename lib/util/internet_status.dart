import 'package:http/http.dart' as http;

class InternetStatus {
  Future<bool> hasInternet() async {
    try {
      final response = await http.head(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
