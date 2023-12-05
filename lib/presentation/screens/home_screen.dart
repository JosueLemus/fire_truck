import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng? _currentLocation;
  LatLng _destinationLocation =
      LatLng(-17.800912, -63.170386); // Santa Cruz, Bolivia
  late Marker _currentLocationMarker;
  late Marker _destinationLocationMarker;
  late Polyline _polyline;
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  bool verifyPermissions = true;
  bool showNoPermission = false;
  bool showDetails = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndInitialize();
  }

  Future<void> _checkLocationPermissionAndInitialize() async {
    FlutterBackgroundService().invoke("setAsForeground");
    final per = await _location.hasPermission();
    bool hasPermission = (per == PermissionStatus.granted ||
        per == PermissionStatus.grantedLimited);
    if (!hasPermission) {
      await _requestLocationPermission();
    }
    await _initializeLocation();
    _subscribeToLocationChanges();
    _setupMarkersAndPolyline();
    setState(() {
      verifyPermissions = false;
    });
  }

  Future<void> _requestLocationPermission() async {
    final requested = await _location.requestPermission();
    if (requested == PermissionStatus.denied ||
        requested == PermissionStatus.deniedForever) {
      setState(() {
        showNoPermission = true;
      });
    } else {
      setState(() {
        verifyPermissions = false;
      });
    }
  }

  Future<void> _initializeLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      _updateCurrentLocationMarker();
    } catch (e) {
      setState(() {
        showNoPermission = true;
      });
    }
  }

  void _subscribeToLocationChanges() {
    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
        if (_currentLocation != null) {
          _updateCurrentLocationMarker();
        }
      });
    });
  }

  void _updateCurrentLocationMarker() {
    setState(() {
      _currentLocationMarker = Marker(
        markerId: const MarkerId("currentLocation"),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: "Mi ubicación"),
      );
    });
  }

  Future<void> _setupMarkersAndPolyline() async {
    _destinationLocationMarker = Marker(
      markerId: const MarkerId("destinationLocation"),
      position: _destinationLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: "Destino"),
    );

    List<LatLng> polylinePoints =
        await _getPolylinePoints(_currentLocation, _destinationLocation);

    setState(() {
      _polyline = Polyline(
        polylineId: const PolylineId("polyline"),
        color: Colors.blue,
        points: polylinePoints,
      );
    });
  }

  Future<List<LatLng>> _getPolylinePoints(
      LatLng? origin, LatLng destination) async {
    // Utiliza un servicio de enrutamiento aquí (por ejemplo, Google Maps Directions API).
    // Reemplaza este código con llamadas reales al servicio de enrutamiento.

    if (origin == null) {
      return [];
    }

    // Simula una solicitud al servicio de enrutamiento.
    // Reemplaza esta lógica con llamadas reales al servicio de enrutamiento.
    List<LatLng> points = [origin];

    // Agrega algunos puntos de manera aleatoria
    for (int i = 0; i < 5; i++) {
      double offsetLat =
          (destination.latitude - origin.latitude) * (i + 1) / 6.0;
      double offsetLng =
          (destination.longitude - origin.longitude) * (i + 1) / 6.0;
      points.add(
          LatLng(origin.latitude + offsetLat, origin.longitude + offsetLng));
    }

    points.add(destination);

    return points;
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showNoPermission) {
      return const Scaffold(
        body: Center(
          child: Text("No tienes permisos de ubicación"),
        ),
      );
    }
    if (verifyPermissions) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          if (showDetails) _buildDetailsCard(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _currentLocation ?? const LatLng(-17.7833, -63.1667),
        zoom: 14.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: {
        if (_currentLocationMarker != null) _currentLocationMarker,
        if (_destinationLocationMarker != null) _destinationLocationMarker
      },
      polylines: {if (_polyline != null) _polyline},
    );
  }

  Widget _buildDetailsCard() {
    return Positioned(
      left: 23,
      right: 23,
      bottom: 23,
      child: BounceInUp(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nombre de usuario",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showDetails = false;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    )
                  ],
                ),
                Text("Direccion"),
                Text("Tipo de incendio"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Agrega aquí la lógica para reproducir el audio
                  },
                  child: const Text("Reproducir Audio"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BounceInRight? _buildFloatingActionButton() {
    return showDetails
        ? null
        : BounceInRight(
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  showDetails = true;
                });
              },
              label: const Text('Detalles de emergencia'),
              icon: const Icon(Icons.fire_truck_rounded),
            ),
          );
  }
}
