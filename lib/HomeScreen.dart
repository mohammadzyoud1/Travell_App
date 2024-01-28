import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:travel_app/FlightScreen.dart';

import 'TheCountryScreen.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/FavoriteScreen.dart';
import 'package:flutter/services.dart' show rootBundle;

class Home_Screen extends StatefulWidget {
  @override
  State<Home_Screen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home_Screen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.green,
          appBar: AppBar(
            title: Text('Travel with us'),
            shadowColor: Colors.amber,
            bottom: TabBar(tabs: [
              Tab(
                  icon: Icon(
                Icons.list,
              )),
              Tab(icon: Icon(Icons.favorite)),
              Tab(
                icon: Icon(Icons.flight),
              )
            ]),
          ),
          body: TabBarView(children: [screen(), favorite_screen(), flight()]),
        ),
      ),
    );
  }
}

String folder_path = 'images/country/';

class screen extends StatefulWidget {
  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> {
  // List to track the tapped items
  List<bool> isTappedList = List.filled(100, false);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // Background image for the screen
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/homescreen_wallpaper.jpg'),
                  fit: BoxFit.fill)),
        ),
        FutureBuilder(
          future: files_count(folder_path),
          builder: (context, snapshot) {
            return ListView.builder(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              itemBuilder: (context, index) {
                return Container(
                  height: 250,
                  // width: double.infinity,
                  child: Center(
                    child: InkWell(
                        onTapCancel: () {
                          setState(() {
                            isTappedList[index] = false;
                          });
                        },
                        onTap: () {
                          setState(() {
                            isTappedList[index] = true;
                          });
                          Future.delayed(Duration(milliseconds: 100), () {
                            setState(() {
                              isTappedList[index] = false;
                            });
                            nextpage(
                                context,
                                fetch_name(
                                  snapshot,
                                  index,
                                  context,
                                ),
                                snapshot.data?[index]);
                          });
                        },
                        onTapDown: (details) {
                          ;
                          setState(() {
                            isTappedList[index] = true;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            isTappedList[index] = false;
                          });
                        },
                        child:
                            // anmation for image containers size on tap
                            Stack(alignment: Alignment.bottomCenter, children: [
                          LayoutBuilder(builder: (context, constraints) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: isTappedList[index] ? 180 : 250,
                              width: isTappedList[index]
                                  ? 200
                                  : constraints.maxWidth,
                              // load the images into the button in the screen
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Image.asset(
                                  snapshot.data?[index] ??
                                      'image-load-failed.jpg',
                                  fit: BoxFit.fill),
                            );
                          }),
                          // country name display
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3)),
                            height: 40,
                            width: isTappedList[index] ? 120 : double.infinity,
                            child: Center(
                              child: Text(
                                fetch_name(snapshot, index, context),
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.8),
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        ])),
                  ),
                );
              },
              itemCount: snapshot.data?.length,
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
            );
          },
        )
      ],
    );
  }
  //Widget build(BuildContext context) {
  //  return Scaffold(
  //      backgroundColor: Colors.red,
  //      body: FutureBuilder(
  //        future: files_count(folder_path),
  //        builder: (context, snapshot) {
  //          return ListView.builder(
  //            itemBuilder: (context, index) {
  //              return ElevatedButton(
  //                style: ButtonStyle(
  //                    maximumSize: MaterialStatePropertyAll(
  //                        Size(button_width, button_height)),
  //                    backgroundColor: MaterialStateProperty.all(Colors.red)),
  //                onPressed: () {
  //                  // to get the value at that index from the list
  //                  nextpage(
  //                      context,
  //                      fetch_name(
  //                        snapshot,
  //                        index,
  //                        context,
  //                      ),
  //                      snapshot.data?[index]);
  //                },
  //                child: Stack(
  //                  alignment: Alignment.bottomCenter,
  //                  children: [
  //                    Container(
  //                      // load the images into the button in the screen
  //                      padding: EdgeInsets.symmetric(vertical: 5),
  //                      child: Image.asset(snapshot.data?[index],
  //                          height: 200,
  //                          width: double.infinity,
  //                          fit: BoxFit.fill),
  //                    ),
  //                    Container(
  //                      decoration:
  //                          BoxDecoration(color: Colors.white.withOpacity(0.3)),
  //                      height: 40,
  //                      child: Center(
  //                        child: Text(
  //                          fetch_name(snapshot, index, context),
  //                          style: TextStyle(
  //                            color: Colors.black.withOpacity(.8),
  //                            fontSize: 25,
  //                          ),
  //                        ),
  //                      ),
  //                    ),
  //                  ],
  //                ),
  //              );
  //            },
  //            itemCount: snapshot.data?.length,
  //            shrinkWrap: false,
  //            scrollDirection: Axis.vertical,
  //          );
  //        },
  //      ));
  //}

  //Fetching nam efrom the path
  String fetch_name(
      AsyncSnapshot<List<dynamic>> snapshot, int index, BuildContext context) {
    // to get the value at that index from the list
    if (snapshot.data?[index] != null) {
      String extract_path_as_string = snapshot.data?[index] as String;
      String name_with_jpg =
          extract_path_as_string.substring(folder_path.length);
      String name_with_out_jpg = name_with_jpg.replaceAll('.jpg', '');
      return name_with_out_jpg;
    } else {
      return 'image-load-failed.jpg';
    }

    // remove the folder path from the name of the index info to keep the country name
  }

  void nextpage(
      BuildContext context, String name_with_out_jpg, String background) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => country(
                  name: name_with_out_jpg,
                  backgorund_path: background,
                )));
  }
}

//files counter
Future<List> files_count(String directoryPath) async {
  int jpgFileCount = 0;

  try {
    // Load the asset manifest to get a list of all assets
    String manifestContent = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> manifest = json.decode(manifestContent);

    // Filter assets with the .jpg extension
    List<String> jpgFiles = manifest.keys
        .where((String key) =>
            key.startsWith(directoryPath) && key.endsWith('.jpg'))
        .toList();
    jpgFileCount = jpgFiles.length;
    return jpgFiles;
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
