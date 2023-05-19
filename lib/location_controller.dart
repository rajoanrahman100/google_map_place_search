import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;

  final Completer<GoogleMapController> completer = Completer();

  CameraPosition kGooglePlex = CameraPosition(target: LatLng(23.7126, 90.4278), zoom: 14);

  var markers = <Marker>[].obs;

  @override
  void onInit() {
    requestLocationPermission();
    // fetchUserLocation();
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission granted
      getTheLocationOfUser();
    } else {
      // Location permission denied again
      openAppSettings(); // Request permission again
    }
  }

  Future<Position> fetchUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    //serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return await Geolocator.getCurrentPosition();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();

    //return Future.error('Location services are disabled.');
  }

  Future<Position> determinePosition() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
      print("Error $error");
    });

    return await Geolocator.getCurrentPosition();
  }

  getTheLocationOfUser() {
    Random random = Random();
    fetchUserLocation().then((value) async {
      print("My Latitude ${value.latitude}");
      print("My Longitude ${value.longitude}");

      lat.value = value.latitude;
      long.value = value.longitude;

      markers.add(Marker(markerId: MarkerId(random.nextInt(100).toString()), position: LatLng(value.latitude, value.longitude)));

      CameraPosition cameraPosition = CameraPosition(zoom: 14, target: LatLng(value.latitude, value.longitude));

      final GoogleMapController googleMapController = await completer.future;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
    // determinePosition().then((value) async {
    //   lat.value = value.latitude;
    //   long.value = value.longitude;
    //
    //   markers.add(Marker(markerId: MarkerId(random.nextInt(100).toString()), position: LatLng(value.latitude, value.longitude)));
    //
    //   CameraPosition cameraPosition = CameraPosition(zoom: 14, target: LatLng(value.latitude, value.longitude));
    //
    //   final GoogleMapController googleMapController = await completer.future;
    //   googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // });
  }
}
