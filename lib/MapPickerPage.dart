// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// class MapPickerPage extends StatefulWidget {
//   const MapPickerPage({Key? key}) : super(key: key);
//
//   @override
//   _MapPickerPageState createState() => _MapPickerPageState();
// }
//
// class _MapPickerPageState extends State<MapPickerPage> {
//   LatLng? _pickedLocation;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pick Home Location'),
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           center: LatLng(37.7749, -122.4194), // Default to San Francisco
//           zoom: 10.0,
//         ),
//         layers: [
//           TileLayerOptions(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c'],
//           ),
//           if (_pickedLocation != null)
//             MarkerLayerOptions(
//               markers: [
//                 Marker(
//                   width: 30.0,
//                   height: 30.0,
//                   point: _pickedLocation!,
//                   child: (ctx) => Container(
//                     child: Icon(Icons.location_pin),
//                   ),
//                 ),
//               ],
//             ),
//         ],
//         children: [Container()],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_pickedLocation != null) {
//             // Return the picked location to the previous screen
//             Navigator.of(context).pop<LatLng>(_pickedLocation!);
//           }
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }
// }
//
// class MarkerLayerOptions {}
