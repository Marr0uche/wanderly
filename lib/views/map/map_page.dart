import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../viewmodels/map_viewmodel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _cityController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MapViewModel>(context, listen: false).init(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MapViewModel>(context);

    // Quand le centre change, on déplace la carte
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(vm.center, 12.0);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("OpenStreetMap Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "Nom de la ville",
                border: OutlineInputBorder(),
              ),
              onSubmitted: vm.searchCity,
            ),
          ),

		  Consumer<MapViewModel>(
  builder: (context, vm, _) {
    if (vm.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.error!),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
    return const SizedBox.shrink();
  },
),

          Text("Latitude: ${vm.latitude}"),
          Text("Longitude: ${vm.longitude}"),

          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(initialCenter: vm.center, initialZoom: 9.0),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c', 'd'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: vm.center,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => vm.searchCity(_cityController.text),
        child: const Icon(Icons.search),
      ),
    );
  }
}
