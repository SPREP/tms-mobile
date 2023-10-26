import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherModel {
  String? iconId;
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

  String dayOrNight = 'day';

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
      this.day}) {
    int hours = DateTime.now().hour;
    dayOrNight = (hours >= 7 && hours <= 20) ? 'day' : 'night';
  }

  void celsiusToFahrenheight() {
    minTemp = toFahrenheight(minTemp);
    maxTemp = toFahrenheight(maxTemp);
    currentTemp = toFahrenheight(currentTemp);
  }

  toFahrenheight(value) {
    if (value == '' || value == null) return;
    return ((int.parse(value) * 9 / 5) + 32).toStringAsFixed(0);
  }

  Icon getIcon(double size, color) {
    IconData icon;

    switch (iconId) {
      case '1':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_sunny
            : WeatherIcons.night_clear;
        break;
      case '2':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_sunny_overcast
            : WeatherIcons.night_partly_cloudy;
        break;
      case '3':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_cloudy
            : WeatherIcons.night_cloudy;
        break;
      case '4':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_showers
            : WeatherIcons.night_showers;
        break;
      case '5':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_rain_mix
            : WeatherIcons.night_rain_mix;
        break;
      case '6':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_sleet
            : WeatherIcons.night_sleet;
        break;
      case '7':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_rain
            : WeatherIcons.night_rain;
        break;
      case '8':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_thunderstorm
            : WeatherIcons.night_thunderstorm;
        break;
      case '9':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_lightning
            : WeatherIcons.night_lightning;
        break;
      case '10':
        icon = dayOrNight == 'day'
            ? WeatherIcons.day_showers
            : WeatherIcons.night_showers;
        break;
      default:
        throw ('No icon found');
    }

    return Icon(
      icon,
      color: color,
      size: size,
    );
  }

  String getIconDefinition() {
    switch (iconId) {
      case '1':
        return 'Fine Weather';
      case '2':
        return 'Partly Cloudy';
      case '3':
        return 'Cloudy';
      case '4':
        return 'Cloudy periods with showers';
      case '5':
        return 'Light Rain';
      case '6':
        return 'Moderate Rain';
      case '7':
        return 'Heavy Rain';
      case '8':
        return 'Partly cloudy with thunderstorm';
      case '9':
        return 'Thunderstorm';
      case '10':
        return 'Squally Showers';
    }
    return '';
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

  @override
  Icon getIcon(double size, color) {
    IconData icon;

    switch (iconId) {
      case '1':
        icon = WeatherIcons.day_sunny;
        break;
      case '2':
        icon = WeatherIcons.day_sunny_overcast;
        break;
      case '3':
        icon = WeatherIcons.day_cloudy;
        break;
      case '4':
        icon = WeatherIcons.day_showers;
        break;
      case '5':
        icon = WeatherIcons.day_rain_mix;
        break;
      case '6':
        icon = WeatherIcons.day_sleet;
        break;
      case '7':
        icon = WeatherIcons.day_rain;
        break;
      case '8':
        icon = WeatherIcons.day_thunderstorm;
        break;
      case '9':
        icon = WeatherIcons.day_lightning;
        break;
      case '10':
        icon = WeatherIcons.day_showers;
        break;
      default:
        throw ('No icon found');
    }

    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
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
