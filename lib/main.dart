// import 'package:flutter/material.dart';
// import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
// import 'package:geolocator/geolocator.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Location Picker',
//       debugShowCheckedModeBanner: false,
//       home: LocationPickerScreen(),
//     );
//   }
// }

// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }

// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _startLocationUpdates();
//   }

//   void _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // تست فعال بودن سرویس موقعیت‌یابی
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _currentPosition = position;
//     });
//     print("Current location: ${position.latitude}, ${position.longitude}");
//   }

//   void _startLocationUpdates() {
//     Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 1, // تغییرات به ازای هر متر
//       ),
//     ).listen((Position position) {
//       setState(() {
//         _currentPosition = position;
//       });
//       print("Updated location: ${position.latitude}, ${position.longitude}");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Location Picker'),
//       ),
//       body: _currentPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : FlutterLocationPicker(
//               initZoom: 11,
//               minZoomLevel: 5,
//               maxZoomLevel: 16,
//               trackMyPosition: true,
//               searchBarBackgroundColor: Colors.white,
//               selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
//               mapLanguage: 'en',
//               onError: (e) => print(e),
//               selectLocationButtonLeadingIcon: const Icon(Icons.check),
//               onPicked: (pickedData) {
//                 print('pic');
//                 print(pickedData.latLong.latitude);
//                 print(pickedData.latLong.longitude);
//                 print(pickedData.address);
//                 print(pickedData.addressData);
//               },
//               onChanged: (pickedData) {
//                 print('ch');
//                 print(pickedData.latLong.latitude);
//                 print(pickedData.latLong.longitude);
//                 print(pickedData.address);
//                 print(pickedData.addressData);
//               },
//               showContributorBadgeForOSM: true,
//               initPosition: LatLong(
//                 _currentPosition!.latitude,
//                 _currentPosition!.longitude,
//               ),
//             ),
//     );
//   }
// }

//ll
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Location Picker',
//       debugShowCheckedModeBanner: false,
//       home: LocationPickerScreen(),
//     );
//   }
// }
//
// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }
//
// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   Position? _currentPosition;
//   final MapController _mapController = MapController();
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _startLocationUpdates();
//   }
//
//   void _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _currentPosition = position;
//       _mapController.move(LatLng(position.latitude, position.longitude), 14.0);
//     });
//     print("Current location: ${position.latitude}, ${position.longitude}");
//   }
//
//   void _startLocationUpdates() {
//     Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 1,
//       ),
//     ).listen((Position position) {
//       setState(() {
//         _currentPosition = position;
//         _mapController.move(
//             LatLng(position.latitude, position.longitude), _mapController.zoom);
//       });
//       print("Updated location: ${position.latitude}, ${position.longitude}");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Location Picker'),
//       ),
//       body: _currentPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(
//           center: LatLng(
//               _currentPosition!.latitude, _currentPosition!.longitude),
//           zoom: 14.0,
//         ),
//         layers: [
//           TileLayerOptions(
//             urlTemplate:
//             "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c'],
//           ),
//           MarkerLayerOptions(
//             markers: [
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: LatLng(_currentPosition!.latitude,
//                     _currentPosition!.longitude),
//                 builder: (ctx) => const Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                   size: 40.0,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

//2

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

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
        distanceFilter: 1,
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
          : FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                initialZoom: 9.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      child: Icon(
                        Icons.location_city,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
