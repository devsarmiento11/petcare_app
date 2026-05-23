import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class VetClinic {
  final String name;
  final String address;
  final LatLng location;

  const VetClinic({
    required this.name,
    required this.address,
    required this.location,
  });
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? mapController;
  StreamSubscription<Position>? _positionSub;

  LatLng? currentPosition;

  // Pangasinan-only vet clinics / branches
  final List<VetClinic> vetClinics = const [
    VetClinic(
      name: "PetCare Veterinary Clinic - Urdaneta",
      address: "Zone 5, Nancamaliran East, Urdaneta City, Pangasinan",
      location: LatLng(15.9788, 120.5718),
    ),
    VetClinic(
      name: "Zacarias Animal Clinic - Urdaneta",
      address: "Bypass Road, Anonas, Urdaneta City, Pangasinan",
      location: LatLng(15.9719, 120.5892),
    ),
    VetClinic(
      name: "Pet Buddies Veterinary Clinic",
      address: "MacArthur Highway, Nancayasan, Urdaneta City, Pangasinan",
      location: LatLng(15.9754, 120.5619),
    ),
    VetClinic(
      name: "Pet Station Veterinary Clinic",
      address: "Alexander Street, Urdaneta City, Pangasinan",
      location: LatLng(15.9765, 120.5703),
    ),
    VetClinic(
      name: "Eastern Pangasinan Veterinary Clinic",
      address: "Zaragoza Street, Tayug, Pangasinan",
      location: LatLng(16.0275, 120.7452),
    ),
    VetClinic(
      name: "Asingan Vet Area",
      address: "Asingan, Pangasinan",
      location: LatLng(16.0057, 120.6695),
    ),
  ];

  late VetClinic selectedVet;

  @override
  void initState() {
    super.initState();
    selectedVet = vetClinics.first;
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
      setState(() {
        // DEMO LOCATION: Urdaneta City, Pangasinan, Philippines
        currentPosition = const LatLng(15.9762, 120.5710);
      });

      _focusUserAndVet();
    });
  }

  void _focusUserAndVet() {
    if (currentPosition == null || mapController == null) return;

    final LatLng user = currentPosition!;
    final LatLng vet = selectedVet.location;

    final southwest = LatLng(
      user.latitude < vet.latitude ? user.latitude : vet.latitude,
      user.longitude < vet.longitude ? user.longitude : vet.longitude,
    );

    final northeast = LatLng(
      user.latitude > vet.latitude ? user.latitude : vet.latitude,
      user.longitude > vet.longitude ? user.longitude : vet.longitude,
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: southwest,
          northeast: northeast,
        ),
        100,
      ),
    );
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  int _distanceInMeters() {
    if (currentPosition == null) return 0;

    return Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      selectedVet.location.latitude,
      selectedVet.location.longitude,
    ).round();
  }

  String _distanceText() {
    final distance = _distanceInMeters();

    if (distance >= 1000) {
      return "${(distance / 1000).toStringAsFixed(2)} km";
    }

    return "$distance m";
  }

  @override
  Widget build(BuildContext context) {
    const double bottomCardHeight = 185;

    return Scaffold(
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(15.9762, 120.5710),
                      zoom: 13,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      mapController = controller;
                      _focusUserAndVet();
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("you"),
                        position: currentPosition!,
                        infoWindow: const InfoWindow(
                          title: "You",
                          snippet: "Current location",
                        ),
                      ),
                      Marker(
                        markerId: const MarkerId("selected_vet"),
                        position: selectedVet.location,
                        infoWindow: InfoWindow(
                          title: selectedVet.name,
                          snippet: selectedVet.address,
                        ),
                      ),
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: [
                          currentPosition!,
                          selectedVet.location,
                        ],
                        color: Colors.black,
                        width: 4,
                      ),
                    },
                  ),
                ),

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
                                "Vet Tracking",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                            ),
                            onPressed: _focusUserAndVet,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 12,
                  right: 12,
                  top: 75,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<VetClinic>(
                        value: selectedVet,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: vetClinics.map((vet) {
                          return DropdownMenuItem<VetClinic>(
                            value: vet,
                            child: Text(
                              vet.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (vet) {
                          if (vet == null) return;

                          setState(() {
                            selectedVet = vet;
                          });

                          _focusUserAndVet();
                        },
                      ),
                    ),
                  ),
                ),

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
                            Icons.local_hospital,
                            size: 64,
                            color: Color(0xff4E7A80),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedVet.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  selectedVet.address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                const Text(
                                  "Distance from you",
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  _distanceText(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
              ],
            ),
    );
  }
}

