// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 flutterBlue.startScan();
//                 flutterBlue.scanResults.listen((event) =>print(event.toString()));
//                 // Listen to scan results
//                 flutterBlue.scanResults.listen((results) {
//                   // do something with scan results
//                   for (ScanResult r in results) {
//                     print('${r.device.name} found! rssi: ${r.rssi}');
//                   }
//                 });
//               },
//               child: const Text('search'),
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 flutterBlue.scanResults.listen((event) =>print(event.toString()));
//                 // Stop scanning
//                 flutterBlue.stopScan();
//               },
//               child: const Text('dad'))
//         ],
//       ),
//     );
//   }
// }
