import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  LatLng? _currentLocation;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (kIsWeb) {
      // برای وب
      setState(() {
        _hasPermission = true;
      });
    } else {
      // برای موبایل
      var status = await Permission.location.status;
      if (status.isGranted) {
        setState(() {
          _hasPermission = true;
        });
      } else if (status.isDenied) {
        var result = await Permission.location.request();
        if (result.isGranted) {
          setState(() {
            _hasPermission = true;
          });
        } else {
          // Handle the case where permission is denied
        }
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_hasPermission) {
      if (kIsWeb) {
        // برای وب
        try {
          final position = await _getWebLocation();
          if (position != null) {
            setState(() {
              _currentLocation = LatLng(position.latitude, position.longitude);
              _controller.text = '${position.latitude}, ${position.longitude}';
            });
          }
        } catch (e) {
          print('Error getting location: $e');
        }
      } else {
        // برای موبایل
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _controller.text = '${position.latitude}, ${position.longitude}';
        });
      }
    } else {
      // Handle the case where permission is not granted
    }
  }

  Future<Position?> _getWebLocation() async {
    final completer = Completer<Position>();
    if (html.window.navigator.geolocation != null) {
      html.window.navigator.geolocation.getCurrentPosition().then((position) {
        final coords = position.coords;
        completer.complete(Position(
          latitude: coords!.latitude!.toDouble(),
          longitude: coords.longitude!.toDouble(),
          timestamp: DateTime.now(),
          altitude: 0,
          speed: 0,
          heading: 0,
          accuracy: 0,
          speedAccuracy: 0, // Ensure these fields are included
          headingAccuracy: 0,
          altitudeAccuracy: 0,
        ));
      }).catchError((e) {
        completer.completeError(e);
      });
    } else {
      completer.completeError('Geolocation is not supported by this browser.');
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Map App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Get Current Location'),
            ),
            if (_currentLocation != null) ...[
              TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Current Location'),
              ),
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: _currentLocation,
                    zoom: 13.0,
                  ),
                  nonRotatedChildren: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _currentLocation!,
                          builder: (ctx) => Container(
                            child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
