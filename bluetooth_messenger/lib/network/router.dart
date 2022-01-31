import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothServiceProvider {
  final List<BluetoothDevice> devicesList = [];
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothServiceProvider() {
    searchForDevices();
  }

  addDeviceToList(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
    }
  }

  searchForDevices() {
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        addDeviceToList(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        addDeviceToList(result.device);
      }
    });
    flutterBlue.startScan();
  }
}

class Client {
  List<BluetoothService> servicesList = [];
  List<BluetoothCharacteristic> characteristics = [];
  final BluetoothDevice device;

  Client({required this.device});

  getServices() async {
    servicesList = await device.discoverServices();
  }

  getCharacteristics() {
    characteristics = servicesList[0].characteristics;
  }

  String read(BluetoothCharacteristic char) {
    var x;
    var sub = char.value.listen((event) {
      x = utf8.decode(event);
    });
    return x;
  }

  void write(BluetoothCharacteristic char, String data) {
    char.write(utf8.encode(data));
  }

  String notify(BluetoothCharacteristic char) {
    var x;
    char.value.listen((event) {
      x = event;
    });
    return utf8.decode(x);
  }
}
