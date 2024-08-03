import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/env/env.dart';

class Weather {
  final LocationApi location;
  final Current current;
  final List<ForecastDay> forecast;

  Weather(
      {required this.location, required this.current, required this.forecast});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: LocationApi.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      forecast: (json['forecast']['forecastday'] as List)
          .map((i) => ForecastDay.fromJson(i))
          .toList(),
    );
  }
}

class LocationApi {
  final String name;
  final String region;
  final String country;
  final String lat;
  final String lon;
  final String tzId;
  final String localtime;

  LocationApi(
      {required this.name,
      required this.region,
      required this.country,
      required this.lat,
      required this.lon,
      required this.tzId,
      required this.localtime});

  factory LocationApi.fromJson(Map<String, dynamic> json) {
    return LocationApi(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toString(),
      lon: json['lon'].toString(),
      tzId: json['tz_id'],
      localtime: json['localtime'],
    );
  }
}

class Current {
  final String tempC;
  final String tempF;
  final String conditionText;
  final String conditionIcon;
  final String windKph;
  final String humidity;
  final String cloud;
  final String feelslikeC;
  final String uv;

  Current(
      {required this.tempC,
      required this.tempF,
      required this.conditionText,
      required this.conditionIcon,
      required this.windKph,
      required this.humidity,
      required this.cloud,
      required this.feelslikeC,
      required this.uv});

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: json['temp_c'].toString(),
      tempF: json['temp_f'].toString(),
      conditionText: json['condition']['text'],
      conditionIcon: "https:${json['condition']['icon']}",
      windKph: json['wind_kph'].toString(),
      humidity: json['humidity'].toString(),
      cloud: json['cloud'].toString(),
      feelslikeC: json['feelslike_c'].toString(),
      uv: json['uv'].toString(),
    );
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final List<Hour> hours;

  ForecastDay({required this.date, required this.day, required this.hours});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
      hours: (json['hour'] as List).map((i) => Hour.fromJson(i)).toList(),
    );
  }
}

class Day {
  final String maxtempC;
  final String mintempC;
  final String avgtempC;
  final String conditionText;
  final String conditionIcon;
  final String uv;

  Day(
      {required this.maxtempC,
      required this.mintempC,
      required this.avgtempC,
      required this.conditionText,
      required this.conditionIcon,
      required this.uv});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'].toString(),
      mintempC: json['mintemp_c'].toString(),
      avgtempC: json['avgtemp_c'].toString(),
      conditionText: json['condition']['text'],
      conditionIcon: "https:${json['condition']['icon']}",
      uv: json['uv'].toString(),
    );
  }
}

class Hour {
  final String time;
  final String tempC;
  final String tempF;
  final String conditionText;
  final String conditionIcon;
  final String windKph;
  final String humidity;
  final String cloud;
  final String feelslikeC;
  final String uv;
  final String chanceOfRain;

  Hour({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.conditionText,
    required this.conditionIcon,
    required this.windKph,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.uv,
    required this.chanceOfRain,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      time: json['time'],
      tempC: json['temp_c'].toString(),
      tempF: json['temp_f'].toString(),
      conditionText: json['condition']['text'],
      conditionIcon: "https:${json['condition']['icon']}",
      windKph: json['wind_kph'].toString(),
      humidity: json['humidity'].toString(),
      cloud: json['cloud'].toString(),
      feelslikeC: json['feelslike_c'].toString(),
      uv: json['uv'].toString(),
      chanceOfRain: json['chance_of_rain'].toString(),
    );
  }
}

class WeatherService {
  final String baseUrl = 'http://api.weatherapi.com/v1/forecast.json';

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?key=${Env.apikey}&q=$cityName&days=10&aqi=no&alerts=no'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
