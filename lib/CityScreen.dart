import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'FavoriteScreen.dart';

class City extends StatefulWidget {
  String country_name;
  String city_name;

  City({required this.country_name, required this.city_name});
  @override
  State<City> createState() =>
      cityscreen(country_name: country_name, city_name: city_name);
}

// List to track the favorite cities and their paths
List<String> favorite_city = [];
List<String> path_list = [];

class cityscreen extends State<City> {
  String country_name;
  String city_name;
  int ind = 0;
  cityscreen({
    required this.country_name,
    required this.city_name,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$city_name')),
      backgroundColor: Colors.amber,
      body: FutureBuilder(
          future: files_count('images/$country_name/$city_name'),
          builder: (context, snapshot) {
            return Stack(
              children: [
                // Background image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'images/$country_name/$country_name/$city_name.jpg'),
                          fit: BoxFit.cover)),
                ),
                GridTile(
                  child: Center(
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        ind = index;
                        return Center(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
                            // Shadow effect for the image
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(5, 5),
                                  blurRadius: 4,
                                  spreadRadius: 4)
                            ]),
                            child: Image.asset(
                              snapshot.data?[index] ??
                                  'images/image-load-failed.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  footer: Row(
                    // Row with favorite button
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, left: 170),
                        child: FloatingActionButton(
                            child: Icon(
                                favorite_city.contains(city_name)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favorite_city.contains(city_name)
                                    ? Colors.amber
                                    : Colors.white),
                            onPressed: () {
                              //adding and removing cities from  favorite
                              if (!favorite_city.contains(city_name)) {
                                favorite_city.add(city_name);
                                path_list.add(snapshot.data?[ind]);
                              } else {
                                favorite_city.remove(city_name);
                                path_list.remove(snapshot.data?[ind]);
                              }
                              setState(() {});
                            }),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
