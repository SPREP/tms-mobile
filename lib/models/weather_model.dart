import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? station;

  bool isDay = true;

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
      this.solarRadiation,
      this.station}) {
    isDayOrNight();
  }

  void isDayOrNight() {}

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

/**
 * Get the background image for the current weather condition
 */
  String getBgImage() {
    String filePath = '';
    switch (iconId) {
      case 5:
      case 6:
      case 7:
        filePath = isDay
            ? 'assets/images/weather/rain_day.jpg'
            : 'assets/images/weather/night_rain.jpg';
        break;
      case 1:
        filePath = isDay
            ? 'assets/images/weather/fine_day.png'
            : 'assets/images/weather/fine_night.jpg';
        break;
      case 2:
      case 3:
      case 4:
      case 8:
      case 9:
      case 10:
        filePath = isDay
            ? 'assets/images/weather/cloudy_day.jpg'
            : 'assets/images/weather/cloudy_night.jpg';
        break;
    }

    return filePath;
  }

  getIcon() {
    String icon;

    switch (iconId) {
      case 1:
        icon = isDay ? 'sunny' : 'night_clear_sky';
        break;
      case 2:
        icon = isDay ? 'day_partial_cloud' : 'night_partial_cloud';
        break;
      case 3:
        icon = isDay ? 'cloudy' : 'cloudy';
        break;

      case 10:
        icon = isDay ? 'snow' : 'snow';
        break;
      case 4:
      case 5:
      case 6:
      case 7:
        icon = 'rain';
        break;
      case 8:
      case 9:
        icon = isDay ? 'thunder_storm' : 'thunder_storm';
        break;
      default:
        icon = '';
        break;
    }

    if (icon == '') return Text(icon);

    return FlareActor(
      "assets/flare/weather_icons/${icon}.flr",
      animation: "activate",
    );
  }

  String getIconDefinition(context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    switch (iconId) {
      case 1:
        return localizations.weatherConditionfineweather;
      case 2:
        return localizations.weatherConditionpartlycloudy;
      case 3:
        return localizations.weatherConditioncloudy;
      case 4:
        return localizations.weatherConditioncloudyperiodswithshowers;
      case 5:
        return localizations.weatherConditionlightrain;
      case 6:
        return localizations.weatherConditionmoderaterain;
      case 7:
        return localizations.weatherConditionheadyrain;
      case 8:
        return localizations.weatherConditionpartycloudywiththunderstorm;
      case 9:
        return localizations.weatherConditionthunderstorm;
      case 10:
        return localizations.weatherConditioncloudyperiodswithshowers;
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
  }) {}

  String getDay(context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    switch (super.day) {
      case 'Monday':
        return localizations.dayMonday;
      case 'Tuesday':
        return localizations.dayTuesday;
      case 'Wednesday':
        return localizations.dayWednesday;
      case 'Thursday':
        return localizations.dayThursday;
      case 'Friday':
        return localizations.dayFriday;
      case 'Saturday':
        return localizations.daySaturday;
      case 'Sunday':
        return localizations.daySunday;
    }
    return "Monday";
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
      super.solarRadiation,
      super.station}) {}
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
  }) {}
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
  }) {}
}
