import 'package:flare_flutter/flare_actor.dart';
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
  String? windDirectionDegree;
  String? solarRadiation;

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
      this.observedDate,
      this.windDirectionDegree,
      this.solarRadiation}) {
    isDayOrNight();
  }

  void isDayOrNight() {
    if (this.solarRadiation != '' && this.solarRadiation != null) {
      //Use solar radiation to determine day or night
      double solar = double.parse(this.solarRadiation.toString());
      if (solar > 50) {
        dayOrNight = 'day';
      } else if (solar < 50) {
        dayOrNight = 'night';
      }
    } else {
      //If solar radiation is not available then use the time
      int hours = DateTime.now().hour;
      dayOrNight = (hours >= 7 && hours <= 20) ? 'day' : 'night';
    }
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

  getIcon() {
    String icon;

    switch (iconId) {
      case 1:
        icon = dayOrNight == 'day' ? 'sunny' : 'night_clear_sky';
        break;
      case 2:
        icon =
            dayOrNight == 'day' ? 'day_partial_cloud' : 'night_partial_cloud';
        break;
      case 3:
        icon = dayOrNight == 'day' ? 'cloudy' : 'cloudy';
        break;

      case 10:
        icon = dayOrNight == 'day' ? 'snow' : 'snow';
        break;
      case 4:
      case 5:
      case 6:
      case 7:
        icon = 'rain';
        break;
      case 8:
      case 9:
        icon = dayOrNight == 'day' ? 'thunder_storm' : 'thunder_storm';
        break;
      default:
        icon = '';
        break;
    }

    if (icon == '') return Text(icon);

    return FlareActor(
      "assets/flare/weather_icons/${icon}.flr",
      animation: "idle",
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
  CurrentWeatherModel(
      {super.iconId,
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
      super.windDirectionDegree,
      super.solarRadiation}) {
    super.isDayOrNight();
  }
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
  }) {
    super.isDayOrNight();
  }
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
  }) {
    super.isDayOrNight();
  }
}
