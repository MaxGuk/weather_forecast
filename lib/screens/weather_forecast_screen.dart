import 'package:weather_example/api/weather_api.dart';
import 'package:weather_example/models/weather_forecast_daily.dart';
import 'package:weather_example/screens/city_screen.dart';
import 'package:weather_example/widgets/bottom_list_view.dart';
import 'package:weather_example/widgets/city_view.dart';
import 'package:weather_example/widgets/detail_view.dart';
import 'package:weather_example/widgets/temp_view.dart';
import 'package:flutter/material.dart';

class WeatherForecastScreen extends StatefulWidget {
  final locationWeather;
  WeatherForecastScreen({this.locationWeather});

  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> forecastObject;
  late String _cityName;

  @override
  void initState() {
    super.initState();

    if (widget.locationWeather != null) {
      forecastObject = Future.value(widget.locationWeather);
    }

    // forecastObject.then((weather) {
    //   print(weather.list[0].weather[0].main);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Weather forecast'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () {
            setState(() {
              forecastObject = WeatherApi().fetchWeatherForecast();
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () async {
              var tappedName = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const CityScreen();
              }));
              if (tappedName != null) {
                setState(() {
                  _cityName = tappedName;
                  forecastObject = WeatherApi()
                      .fetchWeatherForecast(city: _cityName, isCity: true);
                });
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: FutureBuilder<WeatherForecast>(
              future: forecastObject,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      const SizedBox(height: 50.0),
                      CityView(snapshot: snapshot),
                      const SizedBox(height: 50.0),
                      TempView(snapshot: snapshot),
                      const SizedBox(height: 50.0),
                      DetailView(snapshot: snapshot),
                      const SizedBox(height: 50.0),
                      BottomListView(snapshot: snapshot),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text(
                      'City not found\nPlease, enter correct city',
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
