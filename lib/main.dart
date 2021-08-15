// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unused_local_variable, avoid_print, unused_element //5de7fd5d53307753158aeec38a334a55
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        title: 'Weather App',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({required this.title});
  @override
  _HomeViewState createState() => _HomeViewState();
}

List<String> info = [];

class _HomeViewState extends State<HomePage> {
  Future getWeather(String city, List<String> info) async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&APPID='));
    var jsonData = jsonDecode(response.body);
    setState(() {
      if (response.statusCode == 200) {
        info.add(jsonData['name']);
        info.add('${jsonData['main']['temp'].round()}');
        info.add(jsonData['weather'][0]['main']);
      }
    });
  }

  final _cityTextController = TextEditingController();

  void _search() {
    info.clear();
    getWeather(_cityTextController.text, info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (info.length == 3)
          Column(
            children: [
              Text(info[0], style: TextStyle(fontSize: 25)),
              Text(
                info[1] + '°',
                style: TextStyle(fontSize: 100),
              ),
              Text(
                info[2],
                style: TextStyle(fontSize: 40),
              )
            ],
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: SizedBox(
            width: 150,
            child: TextField(
                controller: _cityTextController,
                decoration: InputDecoration(labelText: 'City'),
                cursorColor: Colors.black,
                textAlign: TextAlign.center),
          ),
        ),
        ElevatedButton(onPressed: _search, child: Text('Search')),
      ])),
    );
  }
}
