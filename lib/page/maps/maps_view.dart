import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsView extends StatelessWidget {
  dynamic data;
  MapsView({required this.data ,super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(data['lat'], data['long']),
            zoom: 17,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(data['lat'], data['long']),
                  builder: (context) => Icon(
                    Icons.pin_drop,
                    size: 35,
                    color: Colors.black,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
