import 'package:flutter/material.dart';
import 'CityScreen.dart';
import 'TheCountryScreen.dart';

class favorite_screen extends StatefulWidget {
  @override
  State<favorite_screen> createState() => _favorite_screenState();
}

class _favorite_screenState extends State<favorite_screen> {
  List<String> country_list = ['Turkey', 'Japan', 'Egypt', 'UK', 'Thailand'];

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1), () {
      setState(() {});
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorite'),
        ),
        backgroundColor: Colors.blue,
        body: GridView.builder(
          itemCount: favorite_city.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: 250),
          itemBuilder: (context, index) {
            return ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                onPressed: () {
                  // Determine the country of  the selected favorite city
                  late String country_local;
                  for (var element in country_list) {
                    if (path_list[index].contains(element)) {
                      country_local = element;
                    }
                  }
                  press(context, country_local, favorite_city[index]);
                },
                child: Stack(
                  children: [
                    Container(
                      // Image of the favorite city
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.asset(
                        path_list[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      // display  the name of the favorite city
                      alignment: Alignment.center,
                      child: Text(
                        favorite_city[index],
                        style: TextStyle(fontSize: 30),
                      ),
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.4)),
                    )
                  ],
                ));
          },
        ));
  }
}
