import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class ChooseLocationScreen extends StatefulWidget {
  final LatLng initialLocation;

  const ChooseLocationScreen({
    @required this.initialLocation,
  });

  @override
  _ChooseLocationScreen createState() => _ChooseLocationScreen();
}

class _ChooseLocationScreen extends State<ChooseLocationScreen> {
  LatLng location;

  void initState() {
    super.initState();
    location = widget.initialLocation;
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      location = latlng;
    });
  }

  @override
  Widget build(BuildContext context) {
    var marker = Marker(
      width: 80.0,
      height: 80.0,
      point: location,
      builder: (context) => Container(
        child: Icon(
          Icons.location_on,
          color: Colors.lightBlue,
          size: 36.0,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Location'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, location),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Tap to set location'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: location,
                  zoom: 13.0,
                  onTap: _handleTap,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayerOptions(markers: [marker])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
