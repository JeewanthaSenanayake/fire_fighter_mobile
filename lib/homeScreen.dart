import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  dynamic is_fire = true;
  dynamic sensors = {"s1": "On", "s2": "On", "s3": "On", "s4": "On"};
  dynamic fireType = "";
  bool helpBtn = true;
  Color _textColor = Colors.white;
  late Timer _timer;
  final databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    databaseRef.child("fire_type").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      fireType = data;
    });
    databaseRef.child("sensor").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      sensors = data;
    });
    databaseRef.child("is_fire_detected").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      is_fire = data;
    });
    // Initialize the timer to change text color every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Toggle between white and red
        _textColor = _textColor == Colors.white ? Colors.red : Colors.white;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          is_fire == true
              ? "assets/backgroud_fire.jpeg"
              : "assets/backgroud_no_fire.jpeg",
          height: scrnheight,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: scrnheight * 0.2,
          left: scrnwidth * 0.6,
          child: SizedBox(
            width: scrnwidth * 0.36,
            height: scrnheight * 0.175,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () async {
                  Uri url = Uri(scheme: 'http', host: '172.20.10.4', path: '');
                  if (this.is_fire == true) {
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw Exception('Could not launch $url');
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.live_tv,
                      color: is_fire == true ? _textColor : Colors.grey,
                      size: scrnwidth * 0.05,
                    ),
                    Text(
                      " Go Live ",
                      style: TextStyle(
                          color: is_fire == true ? _textColor : Colors.grey,
                          fontSize: scrnwidth * 0.05),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: is_fire == true ? _textColor : Colors.grey,
                      size: scrnwidth * 0.05,
                    ),
                  ],
                )),
          ),
        ),
        Positioned(
            top: scrnheight * 0.48,
            left: scrnwidth * 0.605,
            child: Container(
              height: scrnheight * 0.375,
              width: scrnheight * 0.375,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  helpBtn == true ? "Help Me" : "Cool",
                  style: TextStyle(
                      color: is_fire == true ? Colors.white : Colors.grey,
                      fontSize: scrnwidth * 0.03),
                ),
                onPressed: () async {
                  if (is_fire == true && helpBtn == true) {
                    Position position = await _determinePosition();
                    writeLatLon(position);
                    fireStart();
                    helpBtn = false;
                  } else {
                    helpBtn = true;
                    fireEnd();
                  }
                },
              ),
            )),
        Positioned(
          top: scrnheight * 0.5,
          left: scrnwidth * 0.83,
          child: is_fire == false
              ? Column(
                  children: [
                    Text("sensors details\n".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontSize: scrnwidth * 0.014)),
                    Text(
                      "Sensors 1 : ${sensors['s1']}",
                      style: TextStyle(
                          color: Colors.white, fontSize: scrnwidth * 0.014),
                    ),
                    Text(
                      "Sensors 2 : ${sensors['s2']}",
                      style: TextStyle(
                          color: Colors.white, fontSize: scrnwidth * 0.014),
                    ),
                    Text(
                      "Sensors 3 : ${sensors['s3']}",
                      style: TextStyle(
                          color: Colors.white, fontSize: scrnwidth * 0.014),
                    ),
                    Text(
                      "Sensors 4 : ${sensors['s4']}",
                      style: TextStyle(
                          color: Colors.white, fontSize: scrnwidth * 0.014),
                    )
                  ],
                )
              : Column(
                  children: [
                    Text("Fire Type\n".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontSize: scrnwidth * 0.014)),
                    Text(
                      fireType,
                      style: TextStyle(
                          color: Colors.white, fontSize: scrnwidth * 0.014),
                    ),
                  ],
                ),
        ),
        Positioned(
            left: scrnwidth * 0.12,
            top: scrnheight * 0.15,
            child: Container(
              height: scrnheight * 0.75,
              child: Image.asset(
                this.is_fire == true ? "assets/fire.gif" : "assets/cool.gif",
                fit: BoxFit.fill,
              ),
            ))
      ]),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> writeLatLon(Position position) async {
    await databaseRef
        .child("location")
        .update({'lat': position.latitude, 'lng': position.longitude});
  }

  Future<void> fireStart() async {
    await databaseRef.child("is_fire").set(true);
  }

  Future<void> fireEnd() async {
    await databaseRef.child("is_fire").set(false);
    await databaseRef.child("is_fighter_ard").set(false);
    await databaseRef.child("is_fire_detected").set(false);
  }
}
