import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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
  final TextEditingController _searchController = TextEditingController();

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
        const SnackBar(
            content: Text('Izin lokasi ditolak secara permanen.')),
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

  void _searchCanteen(String query) {
    final matchedCanteen = _canteenLocations.firstWhere(
      (canteen) => canteen['name'].toLowerCase().contains(query.toLowerCase()),
      orElse: () => {"name": "Tidak ditemukan", "latitude": 0.0, "longitude": 0.0},
    );

    // Proses berdasarkan hasil pencarian
    if (matchedCanteen['name'] != "Tidak ditemukan") {
      print('Kantin ditemukan: ${matchedCanteen['name']}');
      // Lakukan sesuatu, misalnya pindahkan peta ke lokasi kantin
      _mapController.move(
        LatLng(matchedCanteen['latitude'], matchedCanteen['longitude']),
        15.0,
      );
    } else {
      print('Kantin tidak ditemukan');
      // Bisa menampilkan pesan atau melakukan aksi lain
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Lokasi Kantin'),
        backgroundColor: const Color(0xFF4872B1),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? LatLng(-7.284885502334754, 112.79643059976993),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}",
                additionalOptions: const {
                  'accessToken': 'your-mapbox-access-token',
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
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          // Search bar
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: TextField(
              controller: _searchController,
              onSubmitted: _searchCanteen,
              decoration: InputDecoration(
                hintText: 'Mau ke mana hari ini?',
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Informasi kantin di bawah
          if (_selectedCanteen != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _canteenName ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Logika navigasi
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
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
