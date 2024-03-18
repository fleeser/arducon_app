import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:arducon/core/extensions/bluetooth_device_extension.dart';
import 'package:arducon/core/utils/constants/ui_constants.dart';
import 'package:arducon/core/utils/core_utils.dart';
import 'package:arducon/core/utils/enums/toast_type.dart';
import 'package:arducon/src/gamepad/presentation/pages/gamepad_page.dart';
import 'package:arducon/core/res/theme/palette.dart';

class ScanDeviceListItem extends StatelessWidget {

  final ScanResult result;
  
  const ScanDeviceListItem({
    super.key,
    required this.result
  });

  Future<void> onConnect(BuildContext context) async {
    if (!result.advertisementData.connectable) {
      CoreUtils.showToast(
        context,
        type: ToastType.error,
        title: 'Verbindung nicht möglich',
        description: 'Dieses Gerät unterstützt keine Verbindung.'
      );
    }

    bool connectionError = false;
    await result.device.connectAndUpdateStream().catchError((_) {
      CoreUtils.showToast(
        context,
        type: ToastType.error,
        title: 'Verbindung fehlgeschlagen',
        description: 'Die Verbindung ist fehlgeschlagen.'
      );

      connectionError = true;
    });

    if (connectionError) return;

    final List<BluetoothService> services = await result.device.discoverServices();
    
    if (context.mounted && services.isEmpty) {
      CoreUtils.showToast(
        context,
        type: ToastType.error,
        title: 'Kein Service gefunden',
        description: 'Dieses Gerät hat keinen ansprechbaren Service.'
      );

      return;
    }

    final List<BluetoothCharacteristic> characteristics = services.first.characteristics;
    if (context.mounted && characteristics.isEmpty) {
      CoreUtils.showToast(
        context,
        type: ToastType.error,
        title: 'Keine Charakteristik gefunden',
        description: 'Dieses Gerät hat keine ansprechbare Charakteristik.'
      );

      return;
    }

    if (!context.mounted) return;

    MaterialPageRoute route = MaterialPageRoute(
      builder: (BuildContext _) 
        => GamepadPage(
          device: result.device, 
          characteristic: characteristics.first
        )
      );
    Navigator.of(context).push(route);
  }

  String get _platformName => result.device.platformName.isNotEmpty
    ? result.device.platformName
    : 'Unbekannt';

  String get _remoteId => result.device.remoteId.str;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => onConnect(context),
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).padding.left + UIConstants.defaultPadding,
        right: MediaQuery.of(context).padding.right + UIConstants.defaultPadding,
        top: UIConstants.defaultPadding,
        bottom: UIConstants.defaultPadding
      ),
      elevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      hoverElevation: 0.0,
      fillColor: Palette.background,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _platformName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Expletus_Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Palette.primaryText
                  )
                ),
                const SizedBox(height: 8.0),
                Text(
                  _remoteId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Palette.secondaryText
                  )
                )
              ]
            )
          ),
          const SizedBox(width: UIConstants.defaultPadding),
          const Icon(
            Icons.chevron_right_outlined,
            color: Palette.primaryIcon,
            size: 20.0
          )
        ]
      )
    );
  }
}