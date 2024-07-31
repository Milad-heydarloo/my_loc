// // import 'package:flutter/material.dart';
// // import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
// // import 'package:geolocator/geolocator.dart';
//
// // void main() => runApp(const MyApp());
//
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Location Picker',
// //       debugShowCheckedModeBanner: false,
// //       home: LocationPickerScreen(),
// //     );
// //   }
// // }
//
// // class LocationPickerScreen extends StatefulWidget {
// //   @override
// //   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// // }
//
// // class _LocationPickerScreenState extends State<LocationPickerScreen> {
// //   Position? _currentPosition;
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getCurrentLocation();
// //     _startLocationUpdates();
// //   }
//
// //   void _getCurrentLocation() async {
// //     bool serviceEnabled;
// //     LocationPermission permission;
//
// //     // تست فعال بودن سرویس موقعیت‌یابی
// //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       return Future.error('Location services are disabled.');
// //     }
//
// //     permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         return Future.error('Location permissions are denied');
// //       }
// //     }
//
// //     if (permission == LocationPermission.deniedForever) {
// //       return Future.error(
// //           'Location permissions are permanently denied, we cannot request permissions.');
// //     }
//
// //     Position position = await Geolocator.getCurrentPosition();
// //     setState(() {
// //       _currentPosition = position;
// //     });
// //     print("Current location: ${position.latitude}, ${position.longitude}");
// //   }
//
// //   void _startLocationUpdates() {
// //     Geolocator.getPositionStream(
// //       locationSettings: const LocationSettings(
// //         accuracy: LocationAccuracy.high,
// //         distanceFilter: 1, // تغییرات به ازای هر متر
// //       ),
// //     ).listen((Position position) {
// //       setState(() {
// //         _currentPosition = position;
// //       });
// //       print("Updated location: ${position.latitude}, ${position.longitude}");
// //     });
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Flutter Location Picker'),
// //       ),
// //       body: _currentPosition == null
// //           ? const Center(child: CircularProgressIndicator())
// //           : FlutterLocationPicker(
// //               initZoom: 11,
// //               minZoomLevel: 5,
// //               maxZoomLevel: 16,
// //               trackMyPosition: true,
// //               searchBarBackgroundColor: Colors.white,
// //               selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
// //               mapLanguage: 'en',
// //               onError: (e) => print(e),
// //               selectLocationButtonLeadingIcon: const Icon(Icons.check),
// //               onPicked: (pickedData) {
// //                 print('pic');
// //                 print(pickedData.latLong.latitude);
// //                 print(pickedData.latLong.longitude);
// //                 print(pickedData.address);
// //                 print(pickedData.addressData);
// //               },
// //               onChanged: (pickedData) {
// //                 print('ch');
// //                 print(pickedData.latLong.latitude);
// //                 print(pickedData.latLong.longitude);
// //                 print(pickedData.address);
// //                 print(pickedData.addressData);
// //               },
// //               showContributorBadgeForOSM: true,
// //               initPosition: LatLong(
// //                 _currentPosition!.latitude,
// //                 _currentPosition!.longitude,
// //               ),
// //             ),
// //     );
// //   }
// // }
//
// //ll
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_map/flutter_map.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:latlong2/latlong.dart';
// //
// // void main() => runApp(const MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Location Picker',
// //       debugShowCheckedModeBanner: false,
// //       home: LocationPickerScreen(),
// //     );
// //   }
// // }
// //
// // class LocationPickerScreen extends StatefulWidget {
// //   @override
// //   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// // }
// //
// // class _LocationPickerScreenState extends State<LocationPickerScreen> {
// //   Position? _currentPosition;
// //   final MapController _mapController = MapController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getCurrentLocation();
// //     _startLocationUpdates();
// //   }
// //
// //   void _getCurrentLocation() async {
// //     bool serviceEnabled;
// //     LocationPermission permission;
// //
// //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       return Future.error('Location services are disabled.');
// //     }
// //
// //     permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         return Future.error('Location permissions are denied');
// //       }
// //     }
// //
// //     if (permission == LocationPermission.deniedForever) {
// //       return Future.error(
// //           'Location permissions are permanently denied, we cannot request permissions.');
// //     }
// //
// //     Position position = await Geolocator.getCurrentPosition();
// //     setState(() {
// //       _currentPosition = position;
// //       _mapController.move(LatLng(position.latitude, position.longitude), 14.0);
// //     });
// //     print("Current location: ${position.latitude}, ${position.longitude}");
// //   }
// //
// //   void _startLocationUpdates() {
// //     Geolocator.getPositionStream(
// //       locationSettings: const LocationSettings(
// //         accuracy: LocationAccuracy.high,
// //         distanceFilter: 1,
// //       ),
// //     ).listen((Position position) {
// //       setState(() {
// //         _currentPosition = position;
// //         _mapController.move(
// //             LatLng(position.latitude, position.longitude), _mapController.zoom);
// //       });
// //       print("Updated location: ${position.latitude}, ${position.longitude}");
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Flutter Location Picker'),
// //       ),
// //       body: _currentPosition == null
// //           ? const Center(child: CircularProgressIndicator())
// //           : FlutterMap(
// //         mapController: _mapController,
// //         options: MapOptions(
// //           center: LatLng(
// //               _currentPosition!.latitude, _currentPosition!.longitude),
// //           zoom: 14.0,
// //         ),
// //         layers: [
// //           TileLayerOptions(
// //             urlTemplate:
// //             "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
// //             subdomains: ['a', 'b', 'c'],
// //           ),
// //           MarkerLayerOptions(
// //             markers: [
// //               Marker(
// //                 width: 80.0,
// //                 height: 80.0,
// //                 point: LatLng(_currentPosition!.latitude,
// //                     _currentPosition!.longitude),
// //                 builder: (ctx) => const Icon(
// //                   Icons.location_on,
// //                   color: Colors.red,
// //                   size: 40.0,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// //2
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_map/flutter_map.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:latlong2/latlong.dart';
// //
// // void main() => runApp(const MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Location Picker',
// //       debugShowCheckedModeBanner: false,
// //       home: LocationPickerScreen(),
// //     );
// //   }
// // }
// //
// // class LocationPickerScreen extends StatefulWidget {
// //   @override
// //   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// // }
// //
// // class _LocationPickerScreenState extends State<LocationPickerScreen> {
// //   Position? _currentPosition;
// //   late MapController _mapController;
// //   double _zoom = 15.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _mapController = MapController();
// //     _getCurrentLocation();
// //     _startLocationUpdates();
// //   }
// //
// //   void _getCurrentLocation() async {
// //     bool serviceEnabled;
// //     LocationPermission permission;
// //
// //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       return Future.error('Location services are disabled.');
// //     }
// //
// //     permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         return Future.error('Location permissions are denied');
// //       }
// //     }
// //
// //     if (permission == LocationPermission.deniedForever) {
// //       return Future.error(
// //           'Location permissions are permanently denied, we cannot request permissions.');
// //     }
// //
// //     Position position = await Geolocator.getCurrentPosition();
// //     setState(() {
// //       _currentPosition = position;
// //     });
// //     print("Current location: ${position.latitude}, ${position.longitude}");
// //   }
// //
// //   void _startLocationUpdates() {
// //     Geolocator.getPositionStream(
// //       locationSettings: const LocationSettings(
// //         accuracy: LocationAccuracy.medium,
// //         distanceFilter: 1,
// //       ),
// //     ).listen((Position position) {
// //       setState(() {
// //         _currentPosition = position;
// //       });
// //       print("Updated location: ${position.latitude}, ${position.longitude}");
// //     });
// //   }
// //
// //   void _zoomIn() {
// //     setState(() {
// //       _zoom = _zoom + 1;
// //       _mapController.move(_mapController.center, _zoom);
// //     });
// //   }
// //
// //   void _zoomOut() {
// //     setState(() {
// //       _zoom = _zoom - 1;
// //       _mapController.move(_mapController.center, _zoom);
// //     });
// //   }
// //
// //   void _showCurrentLocation() {
// //     if (_currentPosition != null) {
// //       _mapController.move(
// //           LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
// //           _zoom);
// //     }
// //   }
// //
// //   late String apikey =
// //       'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImMzNjVkMDg2NjdmMzgxZDY1ZmI2NzU0ODcwNDJmZTQ1M2I1MzgxODEyMWY5YTE2OTIwNjFlNDY2NDA2MmNlYzE0NjZmNzIzZDEzMzk4NTk1In0.eyJhdWQiOiIyODIxMyIsImp0aSI6ImMzNjVkMDg2NjdmMzgxZDY1ZmI2NzU0ODcwNDJmZTQ1M2I1MzgxODEyMWY5YTE2OTIwNjFlNDY2NDA2MmNlYzE0NjZmNzIzZDEzMzk4NTk1IiwiaWF0IjoxNzIxOTQwODg3LCJuYmYiOjE3MjE5NDA4ODcsImV4cCI6MTcyNDUzMjg4Nywic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.P-HVICCEemigM5vv_lYuxVogPRp3_Tpa1-6zJWONRJ9BfsWXKd4B6FPgnxmJg1wkSGOXc_GFFoeZuFrf9nRfJzwdofkbFbI9yrtWWMATW2PIY8zjd_2SoZ4O94HE-AfyPOO4Dq_V7TJV1xiGinIJdyFCCfMBAuxN-2p8etP5UF2R6r9gDqxXpeVXiHbDx2zB9nTpONG_rlCi26SJ4Y63rDhsAOppdW6v0bP8bF7wkcOJ_z2lwzaWpcOnvJ0uP0cnYc_y9MiINw_P0g79MWMV-ntFNaaj_LU5G_kvSb9y0uWbmFrPgLoEgRFkdkRK2OEAORd9b5ux_iJGnkYV39UHPQ';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Flutter Location Picker'),
// //       ),
// //       body: Stack(
// //         children: [
// //           _currentPosition == null
// //               ? const Center(child: CircularProgressIndicator())
// //               : FlutterMap(
// //                   mapController: _mapController,
// //                   options: MapOptions(
// //                     center: LatLng(_currentPosition!.latitude,
// //                         _currentPosition!.longitude),
// //                     zoom: _zoom,
// //                   ),
// //                   children: [
// //                     TileLayer(
// //                       urlTemplate:
// //                           "https://map.ir/shiveh/xyz/1.0.0/Shiveh:Shiveh@EPSG:3857@png/{z}/{x}/{y}.png?x-api-key=${apikey}",
// //                     ),
// //                     MarkerLayer(
// //                       markers: [
// //                         Marker(
// //                           width: 80.0,
// //                           height: 80.0,
// //                           point: LatLng(_currentPosition!.latitude,
// //                               _currentPosition!.longitude),
// //                           child: Icon(
// //                             Icons.location_pin,
// //                             size: 50.0,
// //                             color: Colors.blue,
// //                           ),
// //                           key: Key(_currentPosition.toString()),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //           Positioned(
// //             bottom: 50,
// //             right: 10,
// //             child: Column(
// //               children: [
// //                 FloatingActionButton(
// //                   onPressed: _zoomIn,
// //                   child: const Icon(Icons.zoom_in),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 FloatingActionButton(
// //                   onPressed: _zoomOut,
// //                   child: const Icon(Icons.zoom_out),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 FloatingActionButton(
// //                   onPressed: _showCurrentLocation,
// //                   child: const Icon(Icons.my_location),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // code bala okyeh
//
//
import 'package:biofpo_loc/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
  late MapController _mapController;
  double _zoom = 18;

  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
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
        accuracy: LocationAccuracy.medium,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      setState(() {
        Location  location=Location(id: '5imz3qage0zszam', user: 'ashi', latitude: position.latitude.toString(), longitude: position.longitude.toString());
orderController.updateLocation(location);
        _currentPosition = position;
      });
      print("Updated location: ${position.latitude}, ${position.longitude}");
    });
  }

  void _zoomIn() {
    setState(() {
      _zoom = (_zoom + 1).clamp(9, 18);
      _mapController.move(_mapController.center, _zoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoom = (_zoom - 1).clamp(9, 18);
      _mapController.move(_mapController.center, _zoom);
    });
  }

  void _showCurrentLocation() {
    if (_currentPosition != null) {
      _mapController.move(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          _zoom);
    }
  }

  late String apikey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImMzNjVkMDg2NjdmMzgxZDY1ZmI2NzU0ODcwNDJmZTQ1M2I1MzgxODEyMWY5YTE2OTIwNjFlNDY2NDA2MmNlYzE0NjZmNzIzZDEzMzk4NTk1In0.eyJhdWQiOiIyODIxMyIsImp0aSI6ImMzNjVkMDg2NjdmMzgxZDY1ZmI2NzU0ODcwNDJmZTQ1M2I1MzgxODEyMWY5YTE2OTIwNjFlNDY2NDA2MmNlYzE0NjZmNzIzZDEzMzk4NTk1IiwiaWF0IjoxNzIxOTQwODg3LCJuYmYiOjE3MjE5NDA4ODcsImV4cCI6MTcyNDUzMjg4Nywic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.P-HVICCEemigM5vv_lYuxVogPRp3_Tpa1-6zJWONRJ9BfsWXKd4B6FPgnxmJg1wkSGOXc_GFFoeZuFrf9nRfJzwdofkbFbI9yrtWWMATW2PIY8zjd_2SoZ4O94HE-AfyPOO4Dq_V7TJV1xiGinIJdyFCCfMBAuxN-2p8etP5UF2R6r9gDqxXpeVXiHbDx2zB9nTpONG_rlCi26SJ4Y63rDhsAOppdW6v0bP8bF7wkcOJ_z2lwzaWpcOnvJ0uP0cnYc_y9MiINw_P0g79MWMV-ntFNaaj_LU5G_kvSb9y0uWbmFrPgLoEgRFkdkRK2OEAORd9b5ux_iJGnkYV39UHPQ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Location Picker'),
      ),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              initialZoom: _zoom,
              minZoom: 8,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://map.ir/shiveh/xyz/1.0.0/Shiveh:Shiveh@EPSG:3857@png/{z}/{x}/{y}.png?x-api-key=${apikey}",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                  child: Icon(
                      Icons.location_pin,
                      size: 50.0,
                      color: Colors.blue,
                    ),
                    key: Key(_currentPosition.toString()),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _showCurrentLocation,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

