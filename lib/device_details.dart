// import 'dart:convert';
//
// import 'package:bluetooth_mannager/model/storage_model.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
//
// class DeviceDetailsPage extends StatefulWidget {
//   const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);
//   final BluetoothDevice device;
//
//
//   @override
//   State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
// }
//
// class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
//   final String eventName = 'unknown';
//   TextEditingController? controller = TextEditingController();
//   @override
//   void initState() {
//     widget.device.state.listen((event) {
//       eventName == event.name;
//     });
//     super.initState();
//   }
//
//   // String defaultDevice = '';
//   // search (){
//   //
//   // }
//   bool isDefault = false;
//
//   Stream<BluetoothDeviceState> deviceState() {
//     return widget.device.state;
//
//   }
//
//
//
//
//   // final DeviceStorageModel _storageDevice = DeviceStorageModel(id: widget.device.id.id, name: widget.device.name, alice: controller!.text, type: widget.device.type);
//   void defaultBtn(BuildContext context) async {
//     // if is  default delete it
//
//     // else add it
//
//
//
//
//     // if (!isDefault) {
//     //   await widget.device.connect();
//     //   await widget.device.pair().then((value) => setState(() {
//     //         isDefault = true;
//     //         saveDevice(DeviceStorageModel(id: widget.device.id.id, name: widget.device.name, alice: controller!.text, type: widget.device.type));
//     //         showMySnackBar(context, 'added successfully');
//     //       }));
//     // } else {
//     //   widget.device.disconnect();
//     //
//     //   widget.device.discoverServices();
//     // }
//   }
//
//
//
//   void showMySnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 4),
//         action: SnackBarAction(
//           label: 'OK',
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }
//   bool addName  = false;
//
//   // save to get storage
//
//   //  read rom get storage
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Device Details')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 children: [
//                   Text('Device Name:  ${widget.device.name}'),
//                   Text('Mac Address:  ${widget.device.id.id}'),
//                   Text('type: ${widget.device.type.name}'),
//                   StreamBuilder(
//                       stream: widget.device.state,
//                       builder: (context, b) {
//                         return Text('Current state of connection: ${b.connectionState.name}');
//                       },),
//                 ],
//               ),
//               ElevatedButton(onPressed: (){
//
//                 box.write(widget.device.id.id, DeviceStorageModel(
//                   name: widget.device.id.id,
//                   id: widget.device.id.id,
//                   alice: controller!.text,
//                   type: widget.device.type
//                 ));
//                 box.save();
//                 //
//                 // final storedDevice = DeviceStorageModel(
//                 //   id: widget.device.id.id,
//                 //   name: widget.device.name,
//                 //   type: widget.device.type,
//                 //   alice: controller!.text,
//                 // );
//                 // box.write(widget.device.id.id, storedDevice.toJson());
//
//
//               }, child: const Text('printer')),
//               ElevatedButton(onPressed: (){
//                 print(box.read(widget.device.id.id));
//
//               },child: const Text('save'),),
//               const Spacer(),
//               Text('Add A Special Alice', style: Theme.of(context).textTheme.titleMedium,),
//               TextFormField(
//                 controller: controller,
//                 decoration: const InputDecoration(
//                   label: Text('re-name you printer'),
//                 ),
//                 validator: (String? name) {
//                   if (name == null && name!.isEmpty) {
//                     return 'Enter your device name first';
//                   } else if (name.length < 2) {
//                     return 'add more letters';
//                   } else {
//                     return null;
//                   }
//                 },
//                 onChanged: (String? value){},
//               ),
//
//               InkWell(
//                 onTap: () {
//                   controller!.text.isEmpty  ?  setState(() =>addName = false):
//                   defaultBtn(context);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   color: Colors.grey.shade100,
//                   child: Row(
//                     children: [
//                       Text(
//                         'Set as default',
//                         style: Theme
//                             .of(context)
//                             .textTheme
//                             .labelLarge,
//                       ),
//                       const Spacer(),
//                       Checkbox(
//                         value: isDefault,
//                         onChanged: (bool? value) {},
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }