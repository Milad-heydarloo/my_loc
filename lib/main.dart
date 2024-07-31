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
class LocationModel {
  final LatLng position;
  final String name;

  LocationModel({required this.position, required this.name});
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

// لیست مکان‌ها با نام‌ها
  List<LocationModel> locations = [
    LocationModel(position: LatLng(35.70601, 51.40525), name: "Tehran"),
    LocationModel(position: LatLng(35.70654, 51.40560), name: "Mashhad"),
    LocationModel(position: LatLng(35.70386, 51.40457), name: "Shiraz"),
    // مکان‌های دیگر را در صورت نیاز اضافه کنید
  ];

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
        Location location = Location(
            id: '5imz3qage0zszam',
            user: 'ashi',
            latitude: position.latitude.toString(),
            longitude: position.longitude.toString());
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
  void _focusOnMarkers() {
    if (_currentPosition == null) return;

    // تمام موقعیت‌های مورد نظر از جمله موقعیت فعلی
    final allLocations = [
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ...locations.map((locationModel) => locationModel.position),
    ];

    // محاسبه باندینگ باکس که تمام موقعیت‌ها را پوشش دهد
    LatLngBounds bounds = LatLngBounds.fromPoints(allLocations);

    // حرکت به محدوده‌ای که تمام موقعیت‌ها دیده شوند
    _mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(
        padding: EdgeInsets.all(50.0), // حاشیه‌ای که می‌خواهید در اطراف نقشه بگذارید
      ),
    );
  }

  late String apikey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImMzNjVkMDg2NjdmMzgxZDY1ZmI2NzU0ODcwNDJmZTQ1M2I1MzgxODEyMWY5YTE2OTIwNjFlNDY2NDA2MmNlYzE0NjZmNzIzZDEzMzk4NTk1In0.eyJhdWQiOiIyODIxMyIsImp0aSI6ImMzNjVkMDg2NjdmMzgxZDY1ZmI2NzU0ODcwNDJmZTQ1M2I1MzgxODEyMWY5YTE2OTIwNjFlNDY2NDA2MmNlYzE0NjZmNzIzZDEzMzk4NTk1IiwiaWF0IjoxNzIxOTQwODg3LCJuYmYiOjE3MjE5NDA4ODcsImV4cCI6MTcyNDUzMjg4Nywic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.P-HVICCEemigM5vv_lYuxVogPRp3_Tpa1-6zJWONRJ9BfsWXKd4B6FPgnxmJg1wkSGOXc_GFFoeZuFrf9nRfJzwdofkbFbI9yrtWWMATW2PIY8zjd_2SoZ4O94HE-AfyPOO4Dq_V7TJV1xiGinIJdyFCCfMBAuxN-2p8etP5UF2R6r9gDqxXpeVXiHbDx2zB9nTpONG_rlCi26SJ4Y63rDhsAOppdW6v0bP8bF7wkcOJ_z2lwzaWpcOnvJ0uP0cnYc_y9MiINw_P0g79MWMV-ntFNaaj_LU5G_kvSb9y0uWbmFrPgLoEgRFkdkRK2OEAORd9b5ux_iJGnkYV39UHPQ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _focusOnMarkers, // فراخوانی تابع برای تمرکز بر روی مارکرها
          ),
        ],
        title: const Text('Flutter Location Picker'),
      ),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
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
                        ...locations.map((locationModel) {
                          return Marker(
                            width: 150.0,
                            height: 100.0,
                            point: locationModel.position,
                            child: GestureDetector(
                              onTap: () {
                                _showLocationDialog(locationModel); // فراخوانی تابع برای نمایش دیالوگ
                              },
                              child: Column(
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        locationModel.name, // نام مکان از مدل
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.location_pin,
                                    size: 50.0,
                                    color: Colors.red, // می‌توانید رنگ دیگری انتخاب کنید
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

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
  void _showLocationDialog(LocationModel locationModel) {
    Get.defaultDialog(
      title: locationModel.name, // نمایش نام مکان به عنوان عنوان دیالوگ
      middleText: "You selected the location at \nLatitude: ${locationModel.position.latitude}\nLongitude: ${locationModel.position.longitude}",
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // بستن دیالوگ
        },
        child: Text("OK"),
      ),
    );
  }

}
