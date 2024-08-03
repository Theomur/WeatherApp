// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:weather_app/pages/location_dialog.dart';
import 'package:weather_app/utils/api_json_parsing.dart';

String location = 'Moscow, Russia';

String degreeSym = "°";
String displayTemp = "100$degreeSym";
String displayIcon = "https://cdn.weatherapi.com/weather/64x64/day/113.png";
String displayMaxTemp = "100$degreeSym";
String displayMinTemp = "-100$degreeSym";
String displayConditionText = "sad";
String displayPerceptionTemp = "101";
String selectedDateText = "Currently";

int selectedDate = 0;

List<String> forecastDayList = [
  "today",
  "today",
  "today",
  "today",
  "today",
  "today",
  "today",
  "today",
  "today",
  "today"
];
List<String> forecastIconList = [
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png",
  "https://cdn.weatherapi.com/weather/64x64/day/113.png"
];
List<String> forecastTempList = [
  "9/10",
  "9/10",
  "9/10",
  "9/10",
  "9/10",
  "9/10",
  "9/10",
  "9/10",
  "9/10",
  "9/10"
];

List<List> hourlyForecastWidgetsList = List.generate(10, (dayIndex) {
  return List.generate(10, (hourIndex) {
    return Text(hourIndex.toString() + dayIndex.toString());
  });
});

Future<List<List<dynamic>>> hourlyForecastGet(context) async {
  String cityName = location.split(",")[0];
  Weather weatherInf = await WeatherService().fetchWeather(cityName);
  DateTime now = DateTime.now();
  int currentHour = now.hour;

  List<ForecastDay> forecast = weatherInf.forecast;
  int hoursBeforeNow = currentHour - 1;

  List<List> hourlyList = List.generate(10, (dayIndex) {
    return List.generate(
        dayIndex == 0
            ? forecast[dayIndex].hours.length - hoursBeforeNow
            : forecast[dayIndex].hours.length, (hourIndex) {
      Hour hoursItem = forecast[dayIndex].hours[hourIndex + hoursBeforeNow];

      if (dayIndex == 0) {
        if (int.parse(hoursItem.time.split(" ")[1].split(":")[0]) >=
            currentHour) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.45),
            ),
            width: 70,
            child: Column(
              children: [
                Text(hoursItem.tempC + degreeSym),
                Text("${hoursItem.chanceOfRain}%"),
                Image.network(hoursItem.conditionIcon),
                int.parse(hoursItem.time.split(" ")[1].split(":")[0]) ==
                        currentHour
                    ? Text("Now")
                    : Text(hoursItem.time.split(" ")[1]),
              ],
            ),
          );
        }
      } else {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.45),
          ),
          width: 70,
          child: Column(
            children: [
              Text(hoursItem.tempC + degreeSym),
              Text("${hoursItem.chanceOfRain}%"),
              Image.network(hoursItem.conditionIcon),
              Text(hoursItem.time.split(" ")[1]),
            ],
          ),
        );
      }
    });
  });

  return hourlyList;
}

Future<List<String>> forecastGetIcons() async {
  String cityName = location.split(",")[0];
  Weather weatherInf = await WeatherService().fetchWeather(cityName);

  List<String> list = ["", "", "", "", "", "", "", "", "", ""];

  for (int i = 0; i < 10; i++) {
    String iconLink = weatherInf.forecast[i].day.conditionIcon;
    list[i] = iconLink;
  }

  return list;
}

Future<List<String>> forecastGetTemps() async {
  String cityName = location.split(",")[0];
  Weather weatherInf = await WeatherService().fetchWeather(cityName);

  List<String> list = ["", "", "", "", "", "", "", "", "", ""];

  for (int i = 0; i < 10; i++) {
    String maxt = weatherInf.forecast[i].day.maxtempC + degreeSym;
    String mint = weatherInf.forecast[i].day.mintempC + degreeSym;

    list[i] = '$maxt/$mint';
  }
  return list;
}

Future<List<String>> dayToString() async {
  String cityName = location.split(",")[0];
  Weather weatherInf = await WeatherService().fetchWeather(cityName);

  List<String> list = ["", "", "", "", "", "", "", "", "", ""];

  for (int i = 0; i < 10; i++) {
    String date = weatherInf.forecast[i].date;

    int day = int.parse(date.split("-")[2]);
    int month = int.parse(date.split("-")[1]);
    String monthStr = getMonth(month);
    int year = int.parse(date.split("-")[0]);

    String weekDay = getDayOfWeek(DateTime(year, month, day));

    list[i] = "$weekDay, $day $monthStr";
  }
  return list;
}

String getMonth(int month) {
  List<String> months = [
    'Jan.',
    'Feb.',
    'Mar.',
    'Apr.',
    'May.',
    'Jun.',
    'Jul.',
    'Aug.',
    'Sep.',
    'Oct.',
    'Nov.',
    'Dec.'
  ];

  if (month < 1 || month > 12) {
    throw ArgumentError("Month must be between 1 and 12");
  }
  return months[month - 1];
}

String getDayOfWeek(DateTime date) {
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  return days[date.weekday - 1];
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;

  const _PageIndicator({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void changeLocationAppBar(String newLocation) {
    List<String> cityCountry = newLocation.split(',');
    setState(() {
      location = "${cityCountry[0]},${cityCountry[2]}";
      weatherUpdate();
    });
  }

  void locationEnterPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return SelectLocation(
          ChangeLocationFunction: changeLocationAppBar,
        );
      },
    );
  }

  Future<void> weatherUpdate() async {
    String cityName = location.split(",")[0];
    Weather weatherInf = await WeatherService().fetchWeather(cityName);
    List<String> forecastDayListAsync = await dayToString();
    List<String> forecastIconListAsync = await forecastGetIcons();
    List<String> forecastTempListAsync = await forecastGetTemps();
    List<List<dynamic>> hourlyForecastWidgetsListTemp = [];
    if (mounted) {
      hourlyForecastWidgetsListTemp = await hourlyForecastGet(context);
    }
    setState(() {
      selectedDate = 0;
      displayTemp = "${weatherInf.forecast[0].day.avgtempC}$degreeSym";
      displayIcon = weatherInf.forecast[0].day.conditionIcon;
      displayMaxTemp = "${weatherInf.forecast[0].day.maxtempC}$degreeSym";
      displayMinTemp = "${weatherInf.forecast[0].day.mintempC}$degreeSym";
      displayConditionText = weatherInf.forecast[0].day.conditionText;
      displayPerceptionTemp = "Feels like ${weatherInf.current.feelslikeC}";

      forecastDayList = forecastDayListAsync;
      forecastIconList = forecastIconListAsync;
      forecastTempList = forecastTempListAsync;
      hourlyForecastWidgetsList = hourlyForecastWidgetsListTemp;
    });

    return Future.delayed(Duration(seconds: 0));
  }

  changeHourlyForecast(int index) {
    return;
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
          onTap: locationEnterPopUp,
          child: Center(child: Text(location, style: TextStyle(fontSize: 20))),
        ),
      ),
      body: LiquidPullToRefresh(
        onRefresh: weatherUpdate,
        animSpeedFactor: 2,
        height: 90,
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        springAnimationDurationInMilliseconds: 800,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primaryFixedDim,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(selectedDateText),
                    Row(
                      children: [
                        Text(
                          displayTemp,
                          style: TextStyle(fontSize: 30),
                        ),
                        Image.network(displayIcon),
                        SizedBox(width: 50),
                        Column(
                          children: [
                            Text(displayConditionText),
                            Text(displayPerceptionTemp),
                          ],
                        ),
                      ],
                    ),
                    Text("Maximum $displayMaxTemp • Minimum $displayMinTemp")
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Container(
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryFixedDim,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(10),
                    itemCount: hourlyForecastWidgetsList[selectedDate].length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: hourlyForecastWidgetsList[selectedDate][index],
                      );
                    },
                  ),
                ),
              ),
            ),
            _PageIndicator(currentIndex: _currentIndex),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 900,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: [
                    Column(
                      children: List.generate(10, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: changeHourlyForecast(index),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(index == 0 ? 10 : 5),
                                  topRight:
                                      Radius.circular(index == 0 ? 10 : 5),
                                  bottomLeft:
                                      Radius.circular(index == 9 ? 10 : 5),
                                  bottomRight:
                                      Radius.circular(index == 9 ? 10 : 5),
                                ),
                                color: index == selectedDate
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.45)
                                    : Theme.of(context)
                                        .colorScheme
                                        .primaryFixedDim,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  index == 0
                                      ? Text(
                                          "Today",
                                          style: TextStyle(fontSize: 20),
                                        )
                                      : Text(
                                          forecastDayList[index],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                  Row(
                                    children: [
                                      Image.network(forecastIconList[index]),
                                      Text(
                                        forecastTempList[index],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Center(
                      child: Text(
                        'Test Text for Second Page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
