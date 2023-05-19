import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map_place_search/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMapScreen extends StatefulWidget {
  const MyMapScreen({Key? key}) : super(key: key);

  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  LocationController locationController = Get.put(LocationController());

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
      print("Error $error");
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Sample App'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // SearchLocation(
          //   apiKey: googleAPiKey,
          //   country: 'BD',
          //   language: 'en',
          //   onSelected: (Place place) async {
          //     print(place.description);
          //   },
          // ),
          Expanded(
              child: Obx(
            () => GoogleMap(
              onMapCreated: (GoogleMapController googleMapController) {
                locationController.completer.complete(googleMapController);
              },
              initialCameraPosition: CameraPosition(target: LatLng(locationController.lat.value, locationController.long.value)),
              markers: Set<Marker>.of(locationController.markers),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locationController.getTheLocationOfUser();
        },
      ),
    );
  }
}
