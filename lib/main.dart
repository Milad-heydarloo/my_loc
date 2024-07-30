import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Location Picker',
      debugShowCheckedModeBanner: false,
      home: LocationPickerScreen(),
    );
  }
}

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdates();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // تست فعال بودن سرویس موقعیت‌یابی
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
    print("Current location: ${position.latitude}, ${position.longitude}");
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // تغییرات به ازای هر متر
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
      print("Updated location: ${position.latitude}, ${position.longitude}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Location Picker'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterLocationPicker(
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 16,
              trackMyPosition: true,
              searchBarBackgroundColor: Colors.white,
              selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
              mapLanguage: 'en',
              onError: (e) => print(e),
              selectLocationButtonLeadingIcon: const Icon(Icons.check),
              onPicked: (pickedData) {
                print('pic');
                print(pickedData.latLong.latitude);
                print(pickedData.latLong.longitude);
                print(pickedData.address);
                print(pickedData.addressData);
              },
              onChanged: (pickedData) {
                print('ch');
                print(pickedData.latLong.latitude);
                print(pickedData.latLong.longitude);
                print(pickedData.address);
                print(pickedData.addressData);
              },
              showContributorBadgeForOSM: true,
              initPosition: LatLong(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
            ),
    );
  }
}
