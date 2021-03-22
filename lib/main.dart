import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/my_icons_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 var country;
 var name;
 var temp;
 var description;
 var humidity;
 var windSpeed;
 


  Future<Position> getPosition() async {
    Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Placemark> getPlacemark(double latitude, double longitude) async {
    List<Placemark> placemark = await Geolocator()
      .placemarkFromCoordinates(latitude, longitude);
    return placemark[0];
  }

    Future getWeather(double latitude, double longitude) async {
    http.Response response = await http.get("https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=a791e2002cc4351387ec77212a9aebf2&units=metric");
    var results = jsonDecode(response.body);
    setState(() {
      this.country = results['sys']['country'];
      this.name = results['name'];
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    getPosition().then((position) {
      getPlacemark(position.latitude, position.longitude).then((data) {
      this.getWeather(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Weather App'),
      ),
      body: Column(
        children: <Widget> [
          Container(
            child: Column(
              children: <Widget>[
                Icon(MyIcons.germany, color: Colors.black, size: 30),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(
                  country != null ? country.toString() : "loading",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600
                  ) 
                 ),
               ),
               Icon(MyIcons.cityscape, color: Colors.black, size: 30),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(
                  name != null ? name.toString() : "loading",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600
                  ) 
                 ),
               ),  
              ],
            ),
          ),
          Expanded(
          child: ListView(
            children: <Widget>[  
          ListTile(
            leading: Icon(MyIcons.thermometer, color: Colors.black, size: 25),
            title: Text("Temperature"),
            trailing: Text(temp != null ? temp.toString() + "\u00B0""C" : "loading"),
          ),
          ListTile(
            leading: Icon(MyIcons.cloudy, color: Colors.black, size: 25),
            title: Text("Weather"),
            trailing: Text(description != null ? description.toString() : "loading"),
          ),
          ListTile(
            leading: Icon(MyIcons.humidity, color: Colors.black, size: 25),
            title: Text("Humidity"),
            trailing: Text(humidity != null ? humidity.toString() : "loading"),
          ),
          ListTile(
            leading: Icon(MyIcons.wind, color: Colors.black, size: 25),
            title: Text("windSpeed"),
            trailing: Text(windSpeed != null ? windSpeed.toString() : "loading"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("App Showing Current Weather As Per Your Location",
              style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600
                    ) ),
            ),
          )
          ],
          ),
          )
        ],
      ),
    );
  }
}
