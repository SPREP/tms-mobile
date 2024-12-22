import 'package:flutter_test/flutter_test.dart';
import 'package:macres/models/weather_model.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Test fahrenheight conversion function', () {
    WeatherModel wm = WeatherModel();
    expect(wm.toFahrenheight('7'), '45');
  });

  test('Test to makesure the TMS 10days URL is exists', () async {
    final url =
        'https://met.gov.to/forecast/10_Days_Outlook/10_Days_Temp_Outlook.pdf';
    final res = await http.get(
      Uri.parse(url),
    );
    expect(res.statusCode, 200);
  });
}
