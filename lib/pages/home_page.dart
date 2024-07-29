// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:weather_app/env/env.dart';
import 'package:weather_app/pages/location_dialog.dart';
import 'package:weatherapi/weatherapi.dart';

String Location = 'Moscow, Russia';

String degreeSym = "°";
String currentTemp = "100$degreeSym";
String currentIcon = "https://cdn.weatherapi.com/weather/64x64/day/113.png";
String maxTemp = "-100$degreeSym";
String minTemp = "200$degreeSym";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void ChangeLocation_AppBar(String newLocation) {
    List<String> cityCountry = newLocation.split(',');
    setState(() {
      Location = "${cityCountry[0]},${cityCountry[2]}";
      WeatherUpdate();
    });
  }

  void LocationEnterPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return SelectLocation(
          ChangeLocationFunction: ChangeLocation_AppBar,
        );
      },
    );
  }

  Future<void> WeatherUpdate() async {
    WeatherRequest wr = WeatherRequest(Env.apikey);
    String cityName = Location.split(",")[0];
    RealtimeWeather rw = await wr.getRealtimeWeatherByCityName(cityName);
    // ForecastWeather fw =
    //     await wr.getForecastWeatherByCityName(cityName); // UNCNOWN TYPE ERROR

    setState(() {
      currentTemp = "${rw.current.tempC}$degreeSym";
      currentIcon = "https:${rw.current.condition.icon}";
      maxTemp = "100";
      minTemp = "100";
    });
    return Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        elevation: 10,
        title: GestureDetector(
          onTap: LocationEnterPopUp,
          child: Center(child: Text(Location, style: TextStyle(fontSize: 20))),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: RefreshIndicator(
            onRefresh: WeatherUpdate,
            child: ListView(
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryFixedDim,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Currently"),
                          Row(
                            children: [
                              Text(
                                currentTemp,
                                style: TextStyle(fontSize: 30),
                              ),
                              Image.network(currentIcon),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Maximum $maxTemp • Minimum $minTemp")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
