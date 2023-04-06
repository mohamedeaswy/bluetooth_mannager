import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'bluetooth_off_screen.dart';
import 'bluetooth_settings_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const BluetoothSettingsScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}
