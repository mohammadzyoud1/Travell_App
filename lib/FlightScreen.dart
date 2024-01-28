import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class flight extends StatefulWidget {
  @override
  State<flight> createState() => flight_screen();
}

class flight_screen extends State<flight> {
  final date_control = TextEditingController();
  final arrival_control = TextEditingController();
  final departure_control = TextEditingController();

  Future<void> fetchFlightData() async {
    String _buildQueryString(Map<String, dynamic> params) {
      return params.entries.map((e) => '${e.key}=${e.value}').join('&');
    }

    final filters = <String, dynamic>{};
    if (departure_control.text.isNotEmpty) {
      filters['icao24'] = departure_control.text;
    }
    if (arrival_control.text.isNotEmpty) {
      filters['serials'] = arrival_control.text;
    }
    if (date_control.text.isNotEmpty) {
      final DateTime parsedDate =
          DateFormat('yyyy-MM-dd').parse(date_control.text);
      filters['time'] = parsedDate.millisecondsSinceEpoch ~/ 1000;
    }
    final apiUrl = 'https://opensky-network.org/api/states/all';

    final filteredUrl = '$apiUrl?${_buildQueryString(filters)}';
    final response = await http.get(Uri.parse('$filteredUrl'));

    if (response.statusCode == 200) {
      // Parse and handle the flight data
      Map<String, dynamic> flightData = json.decode(response.body);
      //List<dynamic> flightData = json.decode(response.body);
      print('Filtered Flight Data: $flightData');

      print(flightData);
    } else {
      // Handle errors
      print('Failed to fetch flight data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150)),
              color: Colors.black),
          width: double.infinity,
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(150)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.asset(
              'images/flight.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: departure_control,
            decoration: InputDecoration(hintText: "Departure"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: arrival_control,
            decoration: InputDecoration(hintText: "Arrival"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: date_control,
            decoration: InputDecoration(
                labelText: "Date ", icon: Icon(Icons.calendar_today)),
            readOnly: true,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
              );
              if (picked != null) {
                String date = DateFormat('yyyy-MM-dd').format(picked);
                setState(() {
                  date_control.text = date;
                });
              } else {
                ;
              }
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            fetchFlightData();
          },
          child: Text('Search'),
          style: ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(250, 35)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20))))),
        )
      ]),
    );
  }
}
