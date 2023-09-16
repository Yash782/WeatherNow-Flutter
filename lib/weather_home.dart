import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_items.dart';
import 'package:weather_app/secertsdata.dart';
import 'package:weather_app/weather_forcast_items.dart';
import 'package:http/http.dart' as http;

class WeatherScrean extends StatefulWidget {
  const WeatherScrean({super.key});

  @override
  State<WeatherScrean> createState() => _WeatherScreanState();
}

class _WeatherScreanState extends State<WeatherScrean> {
  double temp = 0;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Aurangabad';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'),
      );
      final weatherData = jsonDecode(res.body);
      if (weatherData['cod'] != '200') {
        throw 'Sorry for inconvenice an error occured';
      }
      return weatherData;

      //weatherData['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Start of App Bar
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Weather Now",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            style: const ButtonStyle(),
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      //Start of main temp widget
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          //Adding Progress Indication
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          // Displaying Error msg to user
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          // Declare variable to store data.
          final data = snapshot.data!;
          final apiListAccess = data['list'][0];

          //Getting Temp of city and converting to celsius and limiting it to 2 decimal place
          final currectTemp =
              (apiListAccess['main']['temp'] - 273.15).toStringAsFixed(2);

          // Geting sky condition and data for icon
          final skydata = apiListAccess['weather'][0]['description'];
          final iconData = apiListAccess['weather'][0]['main'];

          // Addition Info variabls
          final pressure = (apiListAccess['main']['pressure']).toString();
          final humidity = (apiListAccess['main']['humidity']).toString();
          final windSpeed = (apiListAccess['wind']['speed']).toString();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  elevation: 5,
                  color: const Color.fromRGBO(21, 163, 207, 1),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "$currectTemp° C",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Icon(
                              iconData == 'Rain'
                                  ? Icons.cloudy_snowing
                                  : iconData == 'Clouds'
                                      ? Icons.cloud
                                      : Icons.sunny,
                              size: 60,
                              fill: 0,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              skydata.toString(),
                              style: const TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //End of main temp widget
              const SizedBox(height: 20),
              const Text(
                "Hourly Forecast",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 130,
                child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyforcast = data['list'][index + 1];
                      final hourlySky = hourlyforcast['weather'][0]['main'];
                      // Temp fetched and converted to celcius
                      final hourlyTemp =
                          (hourlyforcast['main']['temp'] - 273.15)
                              .toStringAsFixed(2);
                      //Using sub string method
                      final timeInTxt =
                          data['list'][index + 1]['dt_txt'].toString();
                      //final timeIn12hr = timeInTxt.substring(11, 16);

                      // Using Intle package
                      final dtTime = DateTime.parse(timeInTxt);

                      return HourlyForcast(
                        time: DateFormat.j().format(dtTime),
                        tempreture: hourlyTemp,
                        icon: hourlySky == 'Cloudy'
                            ? Icons.cloud
                            : hourlySky == 'Rain'
                                ? Icons.cloudy_snowing
                                : Icons.sunny,
                      );
                    }),
              ),
              /*              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForcast(
                      time: '00:00',
                      tempreture: '53',
                      icon: Icons.cloud,
                    ),
                    HourlyForcast(
                      time: '00:00',
                      tempreture: '53',
                      icon: Icons.cloud,
                    ),
                    HourlyForcast(
                      time: '00:00',
                      tempreture: '53',
                      icon: Icons.cloud,
                    ),
                    HourlyForcast(
                      time: '00:00',
                      tempreture: '53',
                      icon: Icons.cloud,
                    ),
                  ],
                ),
              ), */

              const SizedBox(height: 10),
              const Text(
                "Additional Info",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              //Additional info cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItems(
                    infoIcon: Icons.water_drop,
                    infoType: "Humidity",
                    infoVal: "$humidity%",
                  ),
                  AdditionalInfoItems(
                    infoIcon: Icons.air,
                    infoType: "Wind Speed",
                    infoVal: "$windSpeed k/h",
                  ),
                  AdditionalInfoItems(
                    infoIcon: Icons.arrow_downward,
                    infoType: "Pressure",
                    infoVal: pressure,
                  ),
                ],
              ),
              //End of additonal info cards
            ]),
          );
        },
      ),
    );
  }
}
