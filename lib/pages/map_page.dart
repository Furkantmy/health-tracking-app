import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng _currentPosition = LatLng(41.015137, 28.979530); // İstanbul
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    // Servis açık mı kontrol et
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konum servisi kapalı. Lütfen açın.')),
      );
      await Geolocator.openLocationSettings();
    }

    // İzin iste
    final status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konum izni verilmedi')),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final newLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentPosition = newLatLng;
      });

      // Haritayı yeni konuma taşı
      _mapController.move(newLatLng, 16.0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum alınamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konumum")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 15.0,
          minZoom: 2.0,
          maxZoom: 19.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.drag,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.mobil_proje',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _checkPermissionAndGetLocation,
        icon: const Icon(Icons.my_location),
        label: const Text('Konumum'),
      ),
    );
  }
}
