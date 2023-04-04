import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'model/storage_model.dart';

class BluetoothSettingsScreen extends StatefulWidget {
  const BluetoothSettingsScreen({super.key});

  @override
  _BluetoothSettingsScreenState createState() =>
      _BluetoothSettingsScreenState();
}

class _BluetoothSettingsScreenState extends State<BluetoothSettingsScreen> {
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
    final flutterBlue = FlutterBluePlus.instance;

    // Start scanning for devices
    flutterBlue.startScan(timeout: const Duration(seconds: 5));

    // Listen for scan results
    final subscription = flutterBlue.scanResults.listen((results) {
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
    flutterBlue.stopScan();

    // Cancel the subscription to prevent memory leaks
    subscription.cancel();
  }
  String _defaultId ='';
   _loadDefaultDevice() {
     _defaultId = StorageService.getDeviceId();
  }

  Future<void> _saveDefaultDeviceId(String deviceId) async {
    // TODO: Implement saving the default Bluetooth device ID to shared preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Default Device'),
            subtitle: _defaultDevice != null
                ? Text(_defaultDevice!.name ?? 'Unknown Device')
                : const Text('Not set'),
            // trailing: ,
          ),
          // const Divider(),
          //  ListTile(
          //   title: const Text('Paired Devices'),
          //   subtitle: const Text('Tap a device to connect'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => PairedDevicesPage()),
          //     );
          //   },
          // ),
          const Divider(),
          ListTile(
            title: const Text('New Devices'),
            subtitle: const Text('Tap to scan for available devices'),
            trailing:
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ),
          Expanded(child: listView())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanForDevices,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  int _selectedIndex = 100;
  Widget listView() => ListView.builder(
        itemCount: _devicesList.length,
        itemBuilder: (context, index) {
          final BluetoothDevice device = _devicesList[index];


          return ListTile(
            selected: _selectedIndex == index || _defaultId == device.id.id ? true : false,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            title: Text(device.name ?? 'Unknown device'),
            subtitle: Text(device.id.toString()),
            trailing:
                _selectedIndex == index ? button(device) : const SizedBox(),
          );
        },
      );
  TextEditingController controller = TextEditingController();
  Widget button(BluetoothDevice device) => ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add custom Alice'),
              content: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  label: Text('re-name you printer'),
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
              actions: <Widget>[
                TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      // await device.connect();
                      // await device.pair().then((value) =>
                          setState(() {
                            StorageService.saveDevice(
                                device.name, device.id.id);
                            _defaultId  = device.id.id;
                          });
                    //   );
                    }
  ),
                // TextButton(
                //     child: const Text('Cancel'),
                //     onPressed: () async {
                //       if (_defaultDevice?.id.id != device.id.id) {
                //         await device.connect();
                //
                //         // _flutterBlue._flutterBlue
                //         await device.pair().then((value) => setState(() {}));
                //         controller.clear();
                //       } else {
                //         device.disconnect();
                //
                //         device.discoverServices();
                //       }
                //     }),
              ],
            );
          },
        );
      },
      child: const Text('set as default'));
}
