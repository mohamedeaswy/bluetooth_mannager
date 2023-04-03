import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'dialog.dart';
import 'main.dart';

class AvailableDevicesScreen extends StatefulWidget {
  const AvailableDevicesScreen({super.key});

  @override
  AvailableDevicesScreenState createState() => AvailableDevicesScreenState();
}

class AvailableDevicesScreenState extends State<AvailableDevicesScreen> {
  List<ScanResult> _scanResults = [];
  List<BluetoothDevice> _bondedDevices = [];
  final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    try {
      // await _bluePrintPos.scan();
      await _flutterBlue.startScan();
      _bondedDevices = await _flutterBlue.bondedDevices;
      print(_bondedDevices);
      setState(() {});
      _flutterBlue.scanResults.listen((results) {
        setState(() {
          _scanResults = results;
        });
      });
    } catch (e) {
      print('Error scanning for Bluetooth devices: $e');
    }
  }

  Future<void> _stopScan() async {
    try {
      await _flutterBlue.stopScan();
    } catch (e) {
      print('Error stopping Bluetooth scan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                ScanResult result = _scanResults[index];
                BluetoothDeviceType type = result.device.type;
                bool isBonded = _bondedDevices.contains(result.device);
                return ListTile(
                  title: Text(result.device.name ?? 'Unknown Device'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Device Type: ${type.name.toString()}'),
                      Text('Mac Address: ${result.device.id.toString()}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    child: const Text('Connect'),
                    onPressed: () {
                      if (!isBonded) {
                        // connect
                        result.device.pair().then((value) {

                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => leadDialog);
                      }
                    },
                  ),
                  onTap: () {
                    if (isBonded) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DeviceScreen(device: result.device)));
                    }else{
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => leadDialog);
                    }
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            child: const Text('Scan for Devices'),
            onPressed: () {
              _startScan();
            },
          ),
        ],
      ),
    );
  }
}
