import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final PocketBase pb = PocketBase('https://saater.liara.run');
  List<Marker> _markers = [];
  Timer? _timer;
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _startFetchingLocations();
  }

  void _startFetchingLocations() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fetchLocations();
    });
  }

  Future<void> _fetchLocations() async {
    try {
      final resultList = await pb.collection('location').getFullList(
        sort: '-created',
      );

      List<Marker> markers = resultList.map((record) {
        var json = record.toJson();
        double latitude = double.tryParse(json['latitude'] ?? '0.0') ?? 0.0;
        double longitude = double.tryParse(json['longitude'] ?? '0.0') ?? 0.0;
        return Marker(
          point: LatLng(latitude, longitude),
          child: Icon(Icons.location_on, color: Colors.red),
        );
      }).toList();

      setState(() {
        _markers = markers;
        if (_markers.isNotEmpty) {
          // Move map to the first marker's position
          _mapController.move(_markers.first.point, 19.0);
        }
      });
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map with OpenStreetMap')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 19.0, // Default zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}
