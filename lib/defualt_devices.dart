import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DefaultDevicesScreen extends StatefulWidget {
  @override
  _DefaultDevicesScreenState createState() => _DefaultDevicesScreenState();
}

class _DefaultDevicesScreenState extends State<DefaultDevicesScreen> {
  FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Default Devices'),
      ),
      body: FutureBuilder<List<BluetoothDevice?>>(
        future: _flutterBlue.connectedDevices,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemBuilder: (c, i) {
                BluetoothDevice device = snapshot.data![i]!;
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.id.toString()),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement disconnecting from the default device
                    },
                    child: Text('Disconnect'),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text('No default device connected');
          }
        },
      ),
    );
  }
}
