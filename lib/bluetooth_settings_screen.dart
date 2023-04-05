import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'model/storage_model.dart';

class BluetoothSettingsScreen extends StatefulWidget {
  const BluetoothSettingsScreen({super.key});

  @override
  BluetoothSettingsScreenState createState() => BluetoothSettingsScreenState();
}

class BluetoothSettingsScreenState extends State<BluetoothSettingsScreen> {
  BluetoothDevice? _defaultDevice;

  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

  @override
  void initState() {
    super.initState();
    _scanForDevices();
    _loadDefaultDevice();
  }

  final List<BluetoothDevice> _devicesList = [];
  Future<void> _scanForDevices() async {
    // Start scanning for devices
    _flutterBlue.startScan(timeout: const Duration(seconds: 5));

    // Listen for scan results

    final subscription = _flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!_devicesList.contains(result.device)) {
          setState(() {
            _devicesList.add(result.device);
          });
        }
      }
    });

    // Stop scanning after 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    _flutterBlue.stopScan();

    // Cancel the subscription to prevent memory leaks
    subscription.cancel();
  }

  String _defaultId = '';
  String _defaultName = '';
  _loadDefaultDevice() {
    setState(() {
      _defaultId = StorageService.getDeviceId();
      _defaultName = StorageService.getDeviceName();
    });
    print(_defaultName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Settings')),
      body: Column(
        children: [
          const ListTile(
            title: Text('New Devices'),
            subtitle: Text('Tap to connect with  any device'),
            // trailing:
            //     IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ),
          Expanded(child: listView())
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
          stream: _flutterBlue.isScanning,
          builder: (context, snapshot) {
            return snapshot.data == false
                ? FloatingActionButton(
                    onPressed: _scanForDevices,
                    child: const Icon(Icons.refresh),
                  )
                : const FloatingActionButton(
                    onPressed: null,
                    child: CircularProgressIndicator(color: Colors.white),
                  );
          }),
    );
  }

  int _selectedIndex = 100;
  String cantConnected = '';
  String selectedDeviceId = '';
  Widget listView() => ListView.builder(
        itemCount: _devicesList.length,
        itemBuilder: (context, index) {
          final BluetoothDevice device = _devicesList[index];
          Color selectedColors = Colors.blue.shade200;
          Color  defaultColor =  Colors.white;
          Color  errorColor =  Colors.red.shade200;
          // /
          Color getColorBasedOnCondition() {
            if (_defaultId ==  device.id.id) {
              return selectedColors;
            } else if (selectedDeviceId == cantConnected) {
              return errorColor;
            } else {
              return defaultColor; // fallback to grey if condition is not found
            }
          }

          Color selectedColor = getColorBasedOnCondition();
          print(selectedColor);
          return Container(
            color: selectedColor,
            child: ListTile(
              selected: _selectedIndex == index || _defaultId == device.id.id
                  ? true
                  : false,
              onTap: () {
                setState(() {
                  _selectedIndex = index;

                  device.connect().then((value) {
                    selectedDeviceId = device.id.id;

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("connected successful ${device.name}"),
                      backgroundColor: Colors.blue,
                    ));
                  }).catchError((e) {
                    cantConnected = device.id.id;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("failed to connect ${device.name}"),
                      backgroundColor: Colors.red,
                    ));
                  });
                });
              },
              title: _defaultId == device.id.id
                  ? Text(_defaultName)
                  : Text(device.name),
              subtitle: Text(device.id.toString()),
              trailing:
                  _selectedIndex == index ? button(device) : const SizedBox(),
            ),
          );
        },
      );

  // Adding custom name pop up
  TextEditingController controller = TextEditingController();
  Widget button(BluetoothDevice device) => ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add Custom Name'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(device.name),
                  Text(device.id.id),
                  Text(device.type.name),
                  TextFormField(
                    onChanged: (String? val) {
                      _defaultName = val ?? '';
                    },
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        // borderSide: const BorderSide(color: Colors.red),
                      ),
                      label: const Text('re-name you printer'),
                    ),
                    validator: (String? name) {
                      if (name == null && name!.isEmpty) {
                        return 'Enter your device name first';
                      } else if (name.length < 2) {
                        return 'add more letters';
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      side: const BorderSide(width: 2
                          // , color: Colors.red
                          ),
                    ),
                    child:
                        const Text('OK', style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      await device.pair().then((value) {
                        setState(() {
                          StorageService.saveDevice(
                              controller.text, device.id.id);
                          _defaultId = device.id.id;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("connected: ${device.id.id}"),
                            backgroundColor: Colors.blue,
                          ));
                        });
                        _loadDefaultDevice();
                        controller.clear();
                        Navigator.pop(context);
                      }).catchError((e) {
                        // StorageService.remove(); this wil make everything wrong
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("failed to connect ${device.name}"),
                          // backgroundColor: Colors.red,
                        ));
                      });
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Set Default'));
}
