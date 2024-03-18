import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:arducon/core/utils/constants/ui_constants.dart';
import 'package:arducon/core/res/theme/palette.dart';
import 'package:arducon/core/utils/core_utils.dart';
import 'package:arducon/core/utils/enums/toast_type.dart';
import 'package:arducon/src/scan/presentation/widgets/scan_device_list_item.dart';

class ScanDeviceList extends StatefulWidget {

  const ScanDeviceList({ super.key });

  @override
  State<ScanDeviceList> createState() => _ScanDeviceListState();
}

class _ScanDeviceListState extends State<ScanDeviceList> {

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;

  List<ScanResult> _scanResults = [];

  void _onScanData(List<ScanResult> results) {
    setState(() { _scanResults = results; });
  }

  void _onScanError(Object _) {
    CoreUtils.showToast(
      context, 
      type: ToastType.error, 
      title: 'Fehler beim Scannen', 
      description: 'Beim Scannen ist ein Fehler aufgetreten.'
    );
  }

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(
      _onScanData, 
      onError: _onScanError
    );

    FlutterBluePlus.startScan(withNames: [ 'Ardubot' ]);
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();

    _scanResultsSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_scanResults.isEmpty) {
      return const Center(
        child: Text(
          'Keine Suchergebnisse bisher.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Hind',
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Palette.secondaryText
          )
        )
      );
    }
    
    return ListView.builder(
      itemCount: _scanResults.length,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + UIConstants.defaultPadding),
      itemBuilder: (BuildContext context, int index) {
        final ScanResult result = _scanResults[index];
        return ScanDeviceListItem(result: result);
      }
    );
  }
}