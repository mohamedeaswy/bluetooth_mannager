// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// import 'device_details.dart';
//
// class PairedDevicesPage extends StatefulWidget {
//   const PairedDevicesPage({super.key});
//
//   @override
//   _PairedDevicesPageState createState() => _PairedDevicesPageState();
// }
//
// class _PairedDevicesPageState extends State<PairedDevicesPage> {
//   final List<BluetoothDevice> _pairedDevicesList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getPairedDevices();
//   }
//
//   Future<void> _getPairedDevices() async {
//     final List<BluetoothDevice> pairedDevices = await FlutterBluePlus.instance.bondedDevices;
//     setState(() {
//       _pairedDevicesList.clear();
//       _pairedDevicesList.addAll(pairedDevices);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Paired Devices'),
//       ),
//       body: _pairedDevicesList.isNotEmpty ? ListView.builder(
//         itemCount: _pairedDevicesList.length,
//         itemBuilder: (context, index) {
//           final device = _pairedDevicesList[index];
//           return ListTile(
//             title: Text(device.name),
//             subtitle: Text(device.id.toString()),
//             onTap: () =>Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DeviceDetailsPage(device: device),
//               ),
//             ),
//           );
//         },
//       ) : const Center(
//         child: Text('There is no  paired devices yet')
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getPairedDevices,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// //
// // class PairedDevicesScreen extends StatefulWidget {
// //   @override
// //   _PairedDevicesScreenState createState() => _PairedDevicesScreenState();
// // }
// //
// // class _PairedDevicesScreenState extends State<PairedDevicesScreen> {
// //   FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Paired Devices'),
// //       ),
// //       body: StreamBuilder<List<BluetoothDevice>>(
// //         stream: _flutterBlue.connectedDevices.asStream(),
// //         initialData: [],
// //         builder: (context, snapshot) {
// //           if (snapshot.hasData) {
// //             List<BluetoothDevice> devices = snapshot.data!;
// //             return ListView.builder(
// //               itemCount: devices.length,
// //               itemBuilder: (context, index) {
// //                 BluetoothDevice device = devices[index];
// //                 return ListTile(
// //                   title: Text(device.name ?? 'Unknown Device'),
// //                   subtitle: Text(device.id.toString()),
// //                   onTap: () {
// //                     // TODO: Implement connecting to the selected Bluetooth device
// //                   },
// //                 );
// //               },
// //             );
// //           } else if (snapshot.hasError) {
// //             return Text('Error: ${snapshot.error}');
// //           } else {
// //             return const CircularProgressIndicator();
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
