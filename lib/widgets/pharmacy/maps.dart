// import 'package:eat_this_app/app/themes/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// // ignore: must_be_immutable
// class MapsPage extends StatelessWidget {
//   MapsPage({super.key});

//   double lat = -7.9552098;
//   double long = 112.6082791;

//   MapController mapController = MapController.withPosition(
//     initPosition: GeoPoint(latitude: -7.9552098, longitude: 112.6082791),
//   );
//   @override
//   Widget build(BuildContext context) {
//     return OSMFlutter(
//       mapIsLoading:
//           const LinearProgressIndicator(color: CIETTheme.primary_color),
//       osmOption: OSMOption(
//         userTrackingOption: UserTrackingOption(enableTracking: true),
//         showZoomController: false,
//         zoomOption: ZoomOption(
//           initZoom: 15,
//           maxZoomLevel: 19,
//           minZoomLevel: 10,
//         ),
//         staticPoints: [
//           StaticPositionGeoPoint(
//             '',
//             const MarkerIcon(
//               icon: Icon(
//                 Icons.person_pin_circle,
//                 color: Colors.red,
//                 size: 100,
//               ),
//             ),
//             [
//               GeoPoint(
//                 latitude: lat,
//                 longitude: long,
//               ),
//             ],
//           ),
//         ],
//       ),
//       controller: mapController,
//     );
//   }
// }
