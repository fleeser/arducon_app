import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:arducon/src/scan/presentation/widgets/scan_device_list.dart';
import 'package:arducon/core/res/theme/palette.dart';

class ScanPage extends StatefulWidget {

  const ScanPage({ super.key });

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  late BluetoothAdapterState _adapterState;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  void _onStateData(BluetoothAdapterState state) {
    setState(() { _adapterState = state; });
  }

  @override
  void initState() {
    super.initState();

    _adapterState = BluetoothAdapterState.unknown;
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen(_onStateData);
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Palette.background,
        title: const Text(
          'Suche',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Expletus_Sans',
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
            color: Palette.primaryText
          )
        )
      ),
      body: _adapterState == BluetoothAdapterState.on
        ? const ScanDeviceList()
        : const Center(
          child: Text(
            'Bitte aktiviere Bluetooth, um deinen Ardubot zu finden.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Hind',
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Palette.secondaryText
            )
          )
        )
    );
  }
}