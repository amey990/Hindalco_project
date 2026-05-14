import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../services/ble_thermometer_service.dart';

class BleThermometerSheet extends StatefulWidget {
  const BleThermometerSheet({super.key});

  @override
  State<BleThermometerSheet> createState() => _BleThermometerSheetState();
}

class _BleThermometerSheetState extends State<BleThermometerSheet> {
  final _service = BleThermometerService();
  BluetoothDevice? _device;
  String _status = 'Bluetooth not connected';
  String? _error;
  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _isReading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scan());
  }

  @override
  void dispose() {
    _service.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Bluetooth Thermometer',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _status,
              style: const TextStyle(
                color: Color(0xFF7D8491),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              _SheetMessage(message: _error!, isError: true),
            ],
            if (_isScanning || _isConnecting || _isReading) ...[
              const SizedBox(height: 14),
              const LinearProgressIndicator(minHeight: 2),
            ],
            const SizedBox(height: 16),
            if (_device != null) _DeviceCard(device: _device!, onConnect: _connect),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isBusy ? null : _scan,
                    icon: const Icon(Icons.bluetooth_searching_rounded),
                    label: const Text('Scan Thermometer'),
                    style: _outlinedStyle(const Color(0xFF1BA7E1)),
                  ),
                ),
              ],
            ),
            if (_isConnected) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isBusy ? null : _readTemperature,
                  icon: const Icon(Icons.thermostat_rounded),
                  label: const Text('Read Temperature'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isConnected && !_isBusy ? _disconnect : null,
                    icon: const Icon(Icons.bluetooth_disabled_rounded),
                    label: const Text('Disconnect'),
                    style: _outlinedStyle(const Color(0xFFE5484D)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isBusy ? null : () => Navigator.pop(context),
                    style: _outlinedStyle(const Color(0xFF515A68)),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool get _isBusy => _isScanning || _isConnecting || _isReading;

  Future<void> _scan() async {
    setState(() {
      _isScanning = true;
      _error = null;
      _status = 'Scanning for SmartHelmetTemp...';
      _device = null;
      _isConnected = false;
    });

    try {
      final device = await _service.scanForThermometer();
      if (!mounted) {
        return;
      }
      setState(() {
        _device = device;
        _status =
            device == null
                ? 'Bluetooth not connected'
                : 'Device found';
        _error =
            device == null
                ? 'SmartHelmetTemp not found. Make sure the thermometer is powered on.'
                : null;
        _isScanning = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isScanning = false;
        _status = 'Bluetooth not connected';
        _error = _cleanBleError(error);
      });
    }
  }

  Future<void> _connect() async {
    final device = _device;
    if (device == null) {
      return;
    }

    setState(() {
      _isConnecting = true;
      _error = null;
      _status = 'Connecting to SmartHelmetTemp...';
    });

    try {
      await _service.connectToDevice(device);
      if (!mounted) {
        return;
      }
      setState(() {
        _isConnected = true;
        _isConnecting = false;
        _status = 'Connected to SmartHelmetTemp';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isConnected = false;
        _isConnecting = false;
        _status = 'Bluetooth not connected';
        _error = _cleanBleError(error);
      });
    }
  }

  Future<void> _readTemperature() async {
    setState(() {
      _isReading = true;
      _error = null;
      _status = 'Reading temperature...';
    });

    try {
      final temperature = await _service.readTemperature();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Temperature captured: ${temperature.toStringAsFixed(1)}°F'),
        ),
      );
      Navigator.pop(context, temperature);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isReading = false;
        _status = 'Connected to SmartHelmetTemp';
        _error = _cleanBleError(error);
      });
    }
  }

  Future<void> _disconnect() async {
    await _service.disconnect();
    if (!mounted) {
      return;
    }
    setState(() {
      _isConnected = false;
      _device = null;
      _status = 'Bluetooth not connected';
      _error = null;
    });
  }

  ButtonStyle _outlinedStyle(Color color) {
    return OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(fontWeight: FontWeight.w900),
    );
  }

  String _cleanBleError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isEmpty) {
      return 'Could not connect to thermometer. Please try again.';
    }
    return message;
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device, required this.onConnect});

  final BluetoothDevice device;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final name =
        device.platformName.isNotEmpty
            ? device.platformName
            : BleThermometerService.targetDeviceName;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.thermostat_outlined,
              color: Color(0xFF1BA7E1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device.remoteId.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7D8491),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onConnect,
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}

class _SheetMessage extends StatelessWidget {
  const _SheetMessage({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? const Color(0xFFE5484D) : const Color(0xFF17A56B);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: color,
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
