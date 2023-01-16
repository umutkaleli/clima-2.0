import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class LocationScreen5Days extends StatefulWidget {
  LocationScreen5Days({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreen5DaysState createState() => _LocationScreen5DaysState();
}

class _LocationScreen5DaysState extends State<LocationScreen5Days> {
  WeatherModel weather = WeatherModel();
  int temperatureNow;
  String weatherIconNow;
  int temperature3hoursLater;
  String weatherIcon3HoursLater;
  int temperature6hoursLater;
  String weatherIcon6HoursLater;
  int temperature9hoursLater;
  String weatherIcon9HoursLater;
  int temperature12hoursLater;
  String weatherIcon12HoursLater;
  int temperature15hoursLater;
  String weatherIcon15HoursLater;
  int temperature18hoursLater;
  String weatherIcon18HoursLater;
  int temperature21hoursLater;
  String weatherIcon21HoursLater;

  String weatherMessage;
  String cityName;
  var sunRise;
  var sunSet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  Column creatingWeatherColumns(
      int hoursLater, String weatherIcon, int temperature) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          getTheHourData(hoursLater),
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        Text(
          '$weatherIcon',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          '$temperature',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperatureNow = 0;
        weatherIconNow = 'Error';
        weatherMessage = 'Unable to get weather data ';
        cityName = '';
        return;
      }
      //Define the temp per 3 hours
      double temp = weatherData['list'][0]['main']['temp'];
      temperatureNow = temp.floor();
      temp = weatherData['list'][1]['main']['temp'];
      temperature3hoursLater = temp.floor();
      temp = weatherData['list'][2]['main']['temp'];
      temperature6hoursLater = temp.floor();
      temp = weatherData['list'][3]['main']['temp'];
      temperature9hoursLater = temp.floor();
      temp = weatherData['list'][4]['main']['temp'];
      temperature12hoursLater = temp.floor();
      temp = weatherData['list'][5]['main']['temp'];
      temperature15hoursLater = temp.floor();
      temp = weatherData['list'][6]['main']['temp'];
      temperature18hoursLater = temp.floor();
      temp = weatherData['list'][7]['main']['temp'];
      temperature21hoursLater = temp.floor();

      var condition = weatherData['list'][0]['weather'][0]['id'];
      weatherIconNow = weather.getWeatherIcon(condition);
      condition = weatherData['list'][1]['weather'][0]['id'];
      weatherIcon3HoursLater = weather.getWeatherIcon(condition);
      condition = weatherData['list'][2]['weather'][0]['id'];
      weatherIcon6HoursLater = weather.getWeatherIcon(condition);
      condition = weatherData['list'][3]['weather'][0]['id'];
      weatherIcon9HoursLater = weather.getWeatherIcon(condition);
      condition = weatherData['list'][4]['weather'][0]['id'];
      weatherIcon12HoursLater = weather.getWeatherIcon(condition);
      condition = weatherData['list'][5]['weather'][0]['id'];
      weatherIcon15HoursLater = weather.getWeatherIcon(condition);
      condition = weatherData['list'][6]['weather'][0]['id'];
      weatherIcon18HoursLater = weather.getWeatherIcon(condition);
      condition = weatherData['list'][7]['weather'][0]['id'];
      weatherIcon21HoursLater = weather.getWeatherIcon(condition);

      weatherMessage = weather.getMessage(temperatureNow);
      cityName = weatherData['city']['name'];

      sunRise = new DateTime(weatherData['city']['sunrise']);
      print(sunRise);
      sunSet = new DateTime(weatherData['city']['sunset']);
      print(sunSet);
    });
  }

  String getTheHourData(int hoursLater) {
    int nowHour = DateTime.now().hour;
    if (hoursLater == 0)
      nowHour = nowHour;
    else
      nowHour += hoursLater;

    nowHour = nowHour % 24;

    if (nowHour == 0) nowHour = 12;

    return nowHour.toString();
  }

  String getTheDayData(int dayLater) {
    int dayWeek = DateTime.now().weekday;

    dayWeek = dayWeek % 7;

    if (dayWeek == 1) return 'Pzt';
    if (dayWeek == 2) return 'Sal';
    if (dayWeek == 3) return 'Çar';
    if (dayWeek == 4) return 'Per';
    if (dayWeek == 5) return 'Cum';
    if (dayWeek == 6)
      return 'Cmt';
    else
      return 'Paz';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData =
                          await weather.getLocationWeatherFor5Days();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityScreen(),
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeatherFor5Days(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$cityName',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$temperatureNow°',
                      style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sunny',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'D:8° ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Y:19°',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      creatingWeatherColumns(0, weatherIconNow, temperatureNow),
                      creatingWeatherColumns(
                          3, weatherIcon3HoursLater, temperature3hoursLater),
                      creatingWeatherColumns(
                          6, weatherIcon6HoursLater, temperature6hoursLater),
                      creatingWeatherColumns(
                          9, weatherIcon9HoursLater, temperature9hoursLater),
                      creatingWeatherColumns(
                          12, weatherIcon12HoursLater, temperature12hoursLater),
                      creatingWeatherColumns(
                          15, weatherIcon15HoursLater, temperature15hoursLater),
                      creatingWeatherColumns(
                          18, weatherIcon18HoursLater, temperature18hoursLater),
                      creatingWeatherColumns(
                          21, weatherIcon21HoursLater, temperature21hoursLater),
                    ],
                  ),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*Padding(
padding: EdgeInsets.only(left: 15.0),
child: Column(
children: <Widget>[
creatingWeatherRows(
temperature: temperatureNow,
weatherIcon: weatherIconNow),
creatingWeatherRows(
temperature: temperature3hoursLater,
weatherIcon: weatherIcon3HoursLater),
creatingWeatherRows(
temperature: temperature6hoursLater,
weatherIcon: weatherIcon6HoursLater),
creatingWeatherRows(
temperature: temperature9hoursLater,
weatherIcon: weatherIcon9HoursLater),
creatingWeatherRows(
temperature: temperature12hoursLater,
weatherIcon: weatherIcon12HoursLater),
creatingWeatherRows(
temperature: temperature15hoursLater,
weatherIcon: weatherIcon15HoursLater),
creatingWeatherRows(
temperature: temperature18hoursLater,
weatherIcon: weatherIcon18HoursLater),
creatingWeatherRows(
temperature: temperature21hoursLater,
weatherIcon: weatherIcon21HoursLater),
],
),


 */
