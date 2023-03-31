import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});
  static const String id = 'googlemaps_screen';

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  // List<Marker> _marker = [];

  // List<Marker> _list = [
  //   Marker(
  //     markerId: MarkerId('1'),
  //     position: LatLng(37.42796133580664, -122.085749655962),
  //   )
  // ];

  // Future<Position> _getUserCurrentLocation() async {
  //   await Geolocator.requestPermission()
  //       .then((value) {})
  //       .onError((error, stackTrace) {
  //     print(error.toString());
  //   });

  //   return await Geolocator.getCurrentPosition();
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _marker.addAll(_list);
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GoogleMap(
  //       mapType: MapType.normal,
  //       markers: Set<Marker>.of(_marker),
  //       initialCameraPosition: _kGooglePlex,
  //       onMapCreated: (GoogleMapController controller) {
  //         _controller.complete(controller);
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         _getUserCurrentLocation().then((value) => print(
  //             value.latitude.toString() + " " + value.longitude.toString()));
  //       },
  //       child: Icon(Icons.location_city),
  //     ),
  //   );
  // }
  String address = '';
  final Completer<GoogleMapController> _controller = Completer();

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> _markers = <Marker>[];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.676141, -73.856085),
    zoom: 12,
  );

  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(13, 13),
        infoWindow: InfoWindow(title: 'some Info')),
  ];
  int id = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.addAll(list);
    //loadData();
  }

  loadData() {
    _getUserCurrentLocation().then((value) async {
      _markers.add(Marker(
          markerId: const MarkerId('SomeId'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: address)));

      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Flutter Google Map'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onTap: (LatLng latlng) {
              Marker newMarker = Marker(
                markerId: MarkerId("$id"),
                position: LatLng(latlng.latitude, latlng.longitude),
                infoWindow: InfoWindow(
                  title:
                      '${latlng.latitude.toStringAsFixed(5)},${latlng.longitude.toStringAsFixed(5)}',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              );
              _markers.add(newMarker);
              setState(() {
                id++;
              });
            },
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height * .18,
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _getUserCurrentLocation().then((value) async {
                        _markers.add(Marker(
                            markerId: const MarkerId('SomeId'),
                            position: LatLng(value.latitude, value.longitude),
                            infoWindow: InfoWindow(title: address)));
                        final GoogleMapController controller =
                            await _controller.future;

                        CameraPosition _kGooglePlex = CameraPosition(
                          target: LatLng(value.latitude, value.longitude),
                          zoom: 14,
                        );
                        controller.animateCamera(
                            CameraUpdate.newCameraPosition(_kGooglePlex));

                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                value.latitude, value.longitude);

                        final add = placemarks.first;
                        address = add.locality.toString() +
                            " " +
                            add.administrativeArea.toString() +
                            " " +
                            add.subAdministrativeArea.toString() +
                            " " +
                            add.country.toString();

                        setState(() {});
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Text(
                          'Current Location',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(address),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
