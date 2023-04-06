import 'package:get_storage/get_storage.dart';

class StorageService {
  static final box = GetStorage();
  static final init = GetStorage.init();

  static Future remove() async {
    await box.erase();
  }

  static void saveDevice(String name, String id) async {
    await remove();

    await box.write('deviceName', name);
    await box.write('deviceId', id);
    print(getDeviceId());
    await box.save();
  }

  static String getDeviceName() {
    return box.read('deviceName') ?? '';
  }

  static String getDeviceId() {
    return box.read('deviceId') ?? '';
  }
}

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class DeviceStorageModel{
//   final String id;
//   final String name;
//   final String alice;
//   final BluetoothDeviceType type;
//
//   DeviceStorageModel({required this.id, required this.name,required this.alice,required this.type});
//   factory DeviceStorageModel.fromJson(Map<String, dynamic> json) {
//     return DeviceStorageModel(
//       id: json['id'],
//       name: json['name'],
//       type: json['type'],
//       alice: json['alice'],
//
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'type': type,
//     'alice': alice,
//   };
// }
