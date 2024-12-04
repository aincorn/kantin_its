import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../core/configs/theme/app_color.dart';

class MapPages extends StatefulWidget {
  const MapPages({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPages> {
  LatLng? _currentLocation = LatLng(-7.282622, 112.795236); // Default lokasi
  LatLng? _selectedCanteen;
  String? _canteenName;
  final MapController _mapController = MapController();

  // Dummy data lokasi kantin
  final List<Map<String, dynamic>> _canteenLocations = [
    {"name": "Kantin Studi Pembangunan", "latitude": -7.282622, "longitude": 112.795236},
    {"name": "Kantin Teknik Fisika", "latitude": -7.284153, "longitude": 112.7961},
    {"name": "Kantin Mesin", "latitude": -7.28446, "longitude": 112.796379},
    {"name": "Kantin Biologi", "latitude": -7.285695, "longitude": 112.794283},
    {"name": "Kantin Perpustakaan", "latitude": -7.281783, "longitude": 112.795508},
    {"name": "Kantin Teknik Informatika", "latitude": -7.280027, "longitude": 112.797024},
    {"name": "Kantin Teknik Sipil", "latitude": -7.280036, "longitude": 112.793113},
    {"name": "Kantin Geomatika", "latitude": -7.280211, "longitude": 112.794486},
    {"name": "Kantin Arsitektur", "latitude": -7.2804, "longitude": 112.793975},
    {"name": "Kantin Teknik Kimia", "latitude": -7.282633, "longitude": 112.797239}
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah GPS aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS tidak aktif. Aktifkan GPS Anda.')),
      );
      return;
    }

    // Meminta izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi ditolak secara permanen.')),
      );
      return;
    }

    // Dapatkan posisi pengguna
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation!, 15.0); // Pindahkan peta ke lokasi pengguna
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonLabelBackgroundColorCreme,
        title: const Text(
          'Peta Lokasi Kantin',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonLabelColorText,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textThirdColor),
        elevation: 1,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  _currentLocation ?? LatLng(-7.284885502334754, 112.79643059976993),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}",
                additionalOptions: const {
                  'accessToken':
                      'sk.eyJ1IjoibmFmaXNhcnlhZGkzMiIsImEiOiJjbTQ5YzJkYngwM2dsMmpxeXAwbWE0eTd0In0.L0_7nvVOuO5_-30Z_7Pubg',
                },
              ),
              MarkerLayer(
                markers: [
                  // Lokasi pengguna
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  // Lokasi kantin
                  ..._canteenLocations.map((canteen) {
                    return Marker(
                      point: LatLng(canteen['latitude'], canteen['longitude']),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // Icon marker
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),

                          // Label nama kantin di samping marker
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 280, // Atur lebar maksimal untuk label
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              canteen['name'],
                              maxLines: 1, // Batasi jumlah baris teks
                              overflow: TextOverflow.ellipsis, // Tampilkan "..." jika teks terlalu panjang
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                            
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          // Informasi kantin di bawah
          if (_selectedCanteen != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.backgroundColor,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _canteenName ?? '',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textThirdColor),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigasi atau logika lain
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                      ),
                      child: const Text('Navigate'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
