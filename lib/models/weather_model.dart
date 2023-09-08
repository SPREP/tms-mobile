import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherModel {
  num? iconId;
  String? humidity;
  String? pressure;
  String? windSpeed;
  String? windDirection;
  String? visibility;
  String? minTemp;
  String? maxTemp;
  String? currentTemp;
  String? caption;
  String? warning;
  String? location;
  String? day;

  WeatherModel(
      {this.iconId,
      this.humidity,
      this.pressure,
      this.windSpeed,
      this.windDirection,
      this.visibility,
      this.minTemp,
      this.maxTemp,
      this.currentTemp,
      this.caption,
      this.warning,
      this.location,
      this.day});

  Icon getIcon(double size, color) {
    switch (iconId) {
      case 1:
        return Icon(
          WeatherIcons.day_sunny,
          color: color,
          size: size,
        );
      case 2:
        return Icon(
          WeatherIcons.day_rain,
          color: color,
          size: size,
        );
      case 3:
        return Icon(
          WeatherIcons.cloudy,
          color: color,
          size: size,
        );
      case 4:
        return Icon(
          WeatherIcons.showers,
          color: color,
          size: size,
        );
      case 5:
        return Icon(
          WeatherIcons.night_clear,
          color: color,
          size: size,
        );
      case 6:
        return Icon(
          WeatherIcons.rain,
          color: color,
          size: size,
        );
    }
    throw ('Unable to find an icon');
  }
}

class TenDaysForecastModel extends WeatherModel {
  TenDaysForecastModel({
    super.iconId,
    super.day,
    super.maxTemp,
    super.minTemp,
    super.location,
  });
}

class CurrentWeatherModel extends WeatherModel {
  CurrentWeatherModel({
    super.iconId,
    super.currentTemp,
    super.humidity,
    super.pressure,
    super.windDirection,
    super.windSpeed,
    super.visibility,
    super.location,
    super.minTemp,
    super.maxTemp,
  });
}

class ThreeHoursForecastModel extends WeatherModel {
  ThreeHoursForecastModel({
    super.iconId,
    super.caption,
    super.currentTemp,
    super.windDirection,
    super.windSpeed,
    super.visibility,
    super.location,
  });
}

class TwentyFourHoursForecastModel extends WeatherModel {
  TwentyFourHoursForecastModel({
    super.location,
    super.iconId,
    super.caption,
    super.minTemp,
    super.maxTemp,
    super.windDirection,
    super.windSpeed,
    super.warning,
  });
}
