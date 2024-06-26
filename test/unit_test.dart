import 'package:flutter_test/flutter_test.dart';
import 'package:macres/models/weather_model.dart';

void main() {
  test('Test fahrenheight conversion function', () {
    WeatherModel wm = WeatherModel();
    expect(wm.toFahrenheight('7'), '45');
  });
}
