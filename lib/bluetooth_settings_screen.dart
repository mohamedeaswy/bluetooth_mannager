import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'components/daialog.dart';
import 'model/storage_model.dart';

class BluetoothSettingsScreen extends StatefulWidget {
  const BluetoothSettingsScreen({super.key});

  @override
  BluetoothSettingsScreenState createState() => BluetoothSettingsScreenState();
}

class BluetoothSettingsScreenState extends State<BluetoothSettingsScreen> {
  BluetoothDevice? _defaultDevice;
  bool isLoad = false;
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> connectedDevices = [];
  void getConn() async {
    connectedDevices = await _flutterBlue.connectedDevices;
  }

  @override
  void initState() {
    super.initState();
    StorageService.init;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDefaultDevice();
      _scanForDevices();
    });

    getConn();
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

  String _defaultId = '.';
  String _defaultName = ' ';
  Future _loadDefaultDevice() async {
    setState(() {
      _defaultId = StorageService.getDeviceId();
      _defaultName = StorageService.getDeviceName();
    });
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
          Expanded(child: listView()),
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
  String cantConnected = 'i';
  String selectedDeviceId = 'l';
  Widget listView() => ListView.builder(
      itemCount: _devicesList.length,
      itemBuilder: (BuildContext context, int index) {
        final BluetoothDevice device = _devicesList[index];
        Color selectedColors = Colors.blue.shade200;
        Color defaultColor = Colors.white;
        Color errorColor = Colors.red.shade200;
        return Container(
          decoration: BoxDecoration(
            color:
                // _defaultId == device.id.id ||
                _selectedIndex == index ? selectedColors : defaultColor,
            // border: Border.all(color: cantConnected == selectedDeviceId ? errorColor : defaultColor),
          ),
          child: ListTile(
            selectedColor: Colors.blue.shade700,
            selected: _selectedIndex == index
                // || connectedDevices.contains(device)
                ? true
                : false,
            onTap: isLoad
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("connecting  is in progress"),
                      backgroundColor: Colors.orange,
                    ));
                  }
                : () async {
                    print(StorageService.getDeviceId());

                    setState(() {
                      isLoad = true;
                      showLoaderDialog(context);
                      print(isLoad);

                      _selectedIndex = index;
                    });
                    // if (isLoad) {
                    //   showLoaderDialog(context);
                    // }
                    await device.connect().then((value) {
                      selectedDeviceId = device.id.id;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("connected successful ${device.name}"),
                        backgroundColor: Colors.blue,
                      ));
                      setState(() {
                        isLoad = false;

                        print(isLoad);
                      });
                      // Navigator.of(context, rootNavigator: true).pop();
                    }).onError((error, stackTrace) {
                      isLoad = false;

                      print(isLoad);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error $error"),
                        backgroundColor: Colors.red,
                      ));
                      setState(() {
                        cantConnected = device.id.id;
                      });
                      // Navigator.of(context, rootNavigator: true).pop();
                    });

                    setState(() {
                      isLoad = false;

                      print(isLoad);
                    });
                    if (mounted) {
                      Navigator.of(context, rootNavigator: false).pop();
                    }
                  }

            // catchError((e) {}
            ,
            title:
                Text(_defaultId == device.id.id ? _defaultName : device.name),
            subtitle: Text(device.id.toString()),
            trailing: _selectedIndex == index
                ? button(device)
                : _defaultId == device.id.id
                    ? const Text('Defualt')
                    : const SizedBox(),
          ),
        );
      });

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
                  Text('Mac ID${device.id.id}'),
                  Text('Type: ${device.type.name}'),
                  const SizedBox(height: 10),
                  TextFormField(
                    // onChanged: (String? val) {
                    //   _defaultName = val ?? '';
                    // },
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                      label: const Text('re-name you printer'),
                    ),
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
                      side: const BorderSide(width: 2),
                    ),
                    child:
                        const Text('OK', style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      await device.pair().then((value) {
                        setState(() {
                          _defaultName = controller.text;
                          StorageService.saveDevice(
                              controller.text, device.id.id);

                          _defaultId = device.id.id;

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("connected: ${device.name}"),
                            backgroundColor: Colors.blue,
                          ));
                        });

                        controller.clear();
                        Navigator.pop(context);
                      }).catchError((e) {
                        // StorageService.remove(); this wil make everything wrong
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("failed to connect ${device.name}")));
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
