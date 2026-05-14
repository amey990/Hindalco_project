import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleThermometerService {
  static const String targetDeviceName = 'SmartHelmetTemp';
  static const String readCommand = 'READ_TEMP';

  static final Guid serviceUuid = Guid(
    '12345678-1234-1234-1234-123456789abc',
  );

  static final Guid commandUuid = Guid(
    'abcdef01-1234-1234-1234-123456789abc',
  );

  static final Guid tempUuid = Guid('abcdef02-1234-1234-1234-123456789abc');

  BluetoothDevice? _device;
  BluetoothCharacteristic? _commandCharacteristic;
  BluetoothCharacteristic? _temperatureCharacteristic;

  BluetoothDevice? get connectedDevice => _device;

  Future<bool> requestPermissions() async {
    debugPrint('BLE permission requested');
    final statuses =
        await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();

    final bluetoothDenied =
        statuses[Permission.bluetoothScan]?.isDenied == true ||
        statuses[Permission.bluetoothConnect]?.isDenied == true;
    if (bluetoothDenied) {
      throw Exception('Bluetooth permission is required to read thermometer.');
    }

    final permanentlyDenied =
        statuses[Permission.bluetoothScan]?.isPermanentlyDenied == true ||
        statuses[Permission.bluetoothConnect]?.isPermanentlyDenied == true ||
        statuses[Permission.locationWhenInUse]?.isPermanentlyDenied == true;
    if (permanentlyDenied) {
      throw Exception('Bluetooth permission is required to read thermometer.');
    }

    return true;
  }

  Future<void> checkBluetoothReady() async {
    final isSupported = await FlutterBluePlus.isSupported;
    if (!isSupported) {
      throw Exception('Bluetooth is not available on this device.');
    }

    final state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      throw Exception('Please turn on Bluetooth and try again.');
    }
  }

  Future<BluetoothDevice?> scanForThermometer({
    Duration timeout = const Duration(seconds: 9),
  }) async {
    await requestPermissions();
    await checkBluetoothReady();

    debugPrint('Scan started');
    final serviceScan = await _scanOnce(
      timeout: const Duration(seconds: 5),
      withServices: [serviceUuid],
    );
    if (serviceScan != null) {
      return serviceScan;
    }

    return _scanOnce(timeout: const Duration(seconds: 4));
  }

  Future<BluetoothDevice?> _scanOnce({
    required Duration timeout,
    List<Guid> withServices = const [],
  }) async {
    BluetoothDevice? foundDevice;
    StreamSubscription<List<ScanResult>>? subscription;

    try {
      await FlutterBluePlus.stopScan();

      final completer = Completer<BluetoothDevice?>();
      subscription = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          if (_isTargetResult(result)) {
            foundDevice = result.device;
            debugPrint('Device found');
            if (!completer.isCompleted) {
              completer.complete(result.device);
            }
            return;
          }
        }
      });

      await FlutterBluePlus.startScan(
        withServices: withServices,
        timeout: timeout,
      );

      foundDevice = await completer.future.timeout(
        timeout,
        onTimeout: () => foundDevice,
      );
      return foundDevice;
    } finally {
      await subscription?.cancel();
      await FlutterBluePlus.stopScan();
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();

    try {
      await device.connect(
        license: License.commercial,
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );
      debugPrint('Connected');

      final services = await device.discoverServices();
      debugPrint('Services discovered');
      final service = services.where((item) => item.uuid == serviceUuid).firstOrNull;
      if (service == null) {
        throw Exception('Thermometer service not found');
      }

      final command = service.characteristics
          .where((item) => item.uuid == commandUuid)
          .firstOrNull;
      if (command == null) {
        throw Exception('Command characteristic not found');
      }

      final temperature = service.characteristics
          .where((item) => item.uuid == tempUuid)
          .firstOrNull;
      if (temperature == null) {
        throw Exception('Temperature characteristic not found');
      }

      await temperature.setNotifyValue(true);

      _device = device;
      _commandCharacteristic = command;
      _temperatureCharacteristic = temperature;
    } catch (error) {
      if (error is Exception &&
          (error.toString().contains('service not found') ||
              error.toString().contains('characteristic not found'))) {
        rethrow;
      }
      throw Exception('Could not connect to thermometer. Please try again.');
    }
  }

  Future<void> disconnect() async {
    final temperature = _temperatureCharacteristic;
    final device = _device;

    try {
      if (temperature != null) {
        await temperature.setNotifyValue(false);
      }
    } catch (_) {}

    try {
      if (device != null) {
        await device.disconnect();
      }
    } catch (_) {}

    _device = null;
    _commandCharacteristic = null;
    _temperatureCharacteristic = null;
  }

  Future<double> readTemperature() async {
    final command = _commandCharacteristic;
    final temperature = _temperatureCharacteristic;
    final device = _device;
    if (device == null || command == null || temperature == null) {
      throw Exception('Could not connect to thermometer. Please try again.');
    }

    StreamSubscription<List<int>>? subscription;
    final completer = Completer<double>();

    try {
      subscription = temperature.onValueReceived.listen((value) {
        if (value.isEmpty) {
          return;
        }
        final raw = utf8.decode(value, allowMalformed: true).trim();
        debugPrint('Raw BLE response: $raw');
        try {
          final parsed = parseTemperature(raw);
          debugPrint('Parsed temperature: $parsed');
          if (!completer.isCompleted) {
            completer.complete(parsed);
          }
        } catch (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        }
      });

      final payload = utf8.encode(readCommand);
      final withoutResponse =
          !command.properties.write && command.properties.writeWithoutResponse;
      await command.write(payload, withoutResponse: withoutResponse);
      debugPrint('READ_TEMP sent');

      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout:
            () => throw Exception(
              'No response from thermometer. Please try again.',
            ),
      );
    } finally {
      await subscription?.cancel();
    }
  }

  double parseTemperature(String raw) {
    final trimmed = raw.trim().replaceAll('\r', '').replaceAll('\n', ' ');
    final match = RegExp(r'-?\d+(?:\.\d+)?').firstMatch(trimmed);
    final value = double.tryParse(match?.group(0) ?? '');
    if (value == null || value.isNaN || value < 50 || value > 120) {
      throw Exception('Invalid temperature response from thermometer.');
    }
    return value;
  }

  bool _isTargetResult(ScanResult result) {
    final names = [
      result.device.platformName,
      result.device.advName,
      result.advertisementData.advName,
    ];
    final hasTargetName = names.any((name) => name == targetDeviceName);
    final hasTargetService =
        result.advertisementData.serviceUuids.contains(serviceUuid);
    return hasTargetName || hasTargetService;
  }
}
