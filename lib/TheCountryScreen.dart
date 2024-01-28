import 'CityScreen.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class country extends StatefulWidget {
  String name;
  String backgorund_path;
  country({super.key, required this.name, required this.backgorund_path});

  @override
  State<country> createState() =>
      country_screen(the_name: name, backgorund_path: backgorund_path);
}

class country_screen extends State<country> {
  String the_name;
  String backgorund_path;
  final mycontrol = ScrollController();
  country_screen({required this.the_name, required this.backgorund_path});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title: Text(the_name),
        ),
        body: FutureBuilder(
          future: files_count('images/$the_name/$the_name'),
          builder: (context, snapshot) {
            //snapshot.data?[index] = images/country/country/city.jpg
            return Stack(
              children: [
                // Background image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    backgorund_path,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  // GridView  to display city images and names
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisExtent: 280,
                        crossAxisCount: 2,
                        mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStatePropertyAll(Colors.red),
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(5))),
                        child: Stack(children: [
                          Container(
                            // City image
                            height: double.infinity,
                            width: double.infinity,
                            child: Image.asset(
                              snapshot.data?[index] ??
                                  'images/image-load-failed.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            //Display city name
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3)),
                            child: Text(
                              extract_name_from_path(snapshot.data?[index] ??
                                  'images/image-load-failed.jpg'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30),
                            ),
                          )
                        ]),
                        onPressed: () {
                          press(
                              context,
                              the_name,
                              extract_name_from_path(snapshot.data?[index] ??
                                  'images/image-load-failed.jpg'));
                        },
                      );
                    },
                    itemCount: (snapshot.data?.length),
                  ),
                )
              ],
            );
          },
        ));
  }

//extract city name fro the path
  String extract_name_from_path(String all_name) {
    print(all_name);
    String path = 'images/$the_name/$the_name/';
    String name_with_jpg = all_name.substring(path.length);
    String name_with_out_jpg = name_with_jpg.replaceAll('.jpg', '');
    return name_with_out_jpg;
  }
}

press(BuildContext context, String country_name, String city_name) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => City(
                country_name: country_name,
                city_name: city_name,
              )));
}
