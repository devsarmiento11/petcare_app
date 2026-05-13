import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? mapController;

  LatLng? currentPosition;

  /// Demo pet location near user.
  /// (Replace with real pet tracking coordinates later.)
  LatLng? luckyPosition;


  StreamSubscription<Position>? _positionSub;

  @override
  void initState() {
    super.initState();
    _startLocationStream();
  }

  Future<void> _startLocationStream() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen((position) {
      final newCurrent = LatLng(position.latitude, position.longitude);
      final newLucky = LatLng(
        position.latitude + 0.002,
        position.longitude + 0.002,
      );

      setState(() {
        currentPosition = newCurrent;
        luckyPosition = newLucky;
      });

      // Keep the camera following the user.
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newCurrent,
            zoom: 16,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double bottomCardHeight = 150;

    return Scaffold(
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Make the map always fill the screen.
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentPosition!,
                      zoom: 16,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    markers: {
                      if (currentPosition != null)
                        Marker(
                          markerId: const MarkerId("you"),
                          position: currentPosition!,
                          infoWindow: const InfoWindow(title: "You"),
                        ),
                      if (luckyPosition != null)
                        Marker(
                          markerId: const MarkerId("lucky"),
                          position: luckyPosition!,
                          infoWindow: const InfoWindow(title: "Lucky"),
                        ),
                    },
                    polylines: {
                      if (currentPosition != null && luckyPosition != null)
                        Polyline(
                          polylineId: const PolylineId("route"),
                          points: [
                            currentPosition!,
                            luckyPosition!,
                          ],
                          color: Colors.black,
                          width: 4,
                        ),
                    },
                  ),
                ),

                // Top pill.
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xff4E7A80),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Tracking",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom card.
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: bottomCardHeight,
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      color: const Color(0xffF4F4F4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.pets,
                            size: 64,
                            color: Color(0xff4E7A80),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Lucky",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text("Dog | Golden Retriever"),
                                const Spacer(),
                                const Text(
                                  "Distance Between Lucky and you",
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  "${_distanceInMeters()}m",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.location_on_outlined, size: 30),
                        ],
                      ),
                    ),
                  ),
                ),

                // Ensures the map accounts for the bottom card so it stays visible.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomCardHeight,
                  child: IgnorePointer(
                    child: const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
    );
  }

  int _distanceInMeters() {
    if (currentPosition == null || luckyPosition == null) return 0;

    return Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      luckyPosition!.latitude,
      luckyPosition!.longitude,
    ).round();
  }
}