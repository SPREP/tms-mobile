import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String? observedDate;

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
      this.day,
      this.observedDate}) {
    int hours = DateTime.now().hour;
    dayOrNight = (hours >= 7 && hours <= 20) ? 'day' : 'night';
  }

  void celsiusToFahrenheight() {
    minTemp = toFahrenheight(minTemp);
    maxTemp = toFahrenheight(maxTemp);
    currentTemp = toFahrenheight(currentTemp);
  }

  String getObservedTime() {
    if (observedDate == null) {
      return '';
    }

    DateFormat format = DateFormat('E, dd MMM yyyy HH:mm:ss Z');
    DateTime parsedDate = format.parse(observedDate!);

    DateFormat displayFormat = DateFormat('h:mm a');
    return displayFormat.format(parsedDate);
  }

  toFahrenheight(value) {
    if (value == '' || value == null) return;
    return ((int.parse(value) * 9 / 5) + 32).toStringAsFixed(0);
  }

  Image getIcon(double width, double height) {
    String icon;

    switch (iconId) {
      case 1:
        icon =
            dayOrNight == 'day' ? 'day_clear.png' : 'night_full_moon_clear.png';
        break;
      case 2:
        icon = dayOrNight == 'day'
            ? 'day_partial_cloud.png'
            : 'night_full_moon_partial_cloud.png';
        break;
      case 3:
        icon = dayOrNight == 'day' ? 'cloudy.png' : 'cloudy.png';
        break;
      case 4:
      case 6:
      case 10:
        icon =
            dayOrNight == 'day' ? 'day_sleet.png' : 'night_full_moon_sleet.png';
        break;
      case 7:
        icon = 'rain.png';
        break;
      case 5:
        icon =
            dayOrNight == 'day' ? 'day_rain.png' : 'night_full_moon_rain.png';
        break;
      case 8:
      case 9:
        icon = dayOrNight == 'day'
            ? 'day_rain_thunder.png'
            : 'night_full_moon_rain_thunder.png';
        break;
      default:
        icon =
            dayOrNight == 'day' ? 'day_clear.png' : 'night_full_moon_clear.png';
    }

    return Image.asset(
      'assets/images/${icon}',
      width: width,
      height: height,
    );
  }

  String getIconDefinition() {
    switch (iconId) {
      case 1:
        return 'Fine Weather';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Cloudy';
      case 4:
        return 'Cloudy periods with showers';
      case 5:
        return 'Light Rain';
      case 6:
        return 'Moderate Rain';
      case 7:
        return 'Heavy Rain';
      case 8:
        return 'Partly cloudy with thunderstorm';
      case 9:
        return 'Thunderstorm';
      case 10:
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
  }) {
    dayOrNight = 'day';
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
    super.observedDate,
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
