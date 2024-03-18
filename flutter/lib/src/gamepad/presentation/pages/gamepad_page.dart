import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:arducon/core/extensions/bluetooth_device_extension.dart';
import 'package:arducon/core/utils/constants/ui_constants.dart';
import 'package:arducon/src/gamepad/presentation/widgets/gamepad_action_button.dart';
import 'package:arducon/src/gamepad/presentation/widgets/gamepad_top_button.dart';
import 'package:arducon/core/utils/enums/toast_type.dart';
import 'package:arducon/core/res/theme/palette.dart';
import 'package:arducon/core/utils/core_utils.dart';
import 'package:arducon/src/gamepad/presentation/widgets/x_joystick.dart';
import 'package:arducon/src/gamepad/presentation/widgets/y_joystick.dart';

class GamepadPage extends StatefulWidget {

  final BluetoothDevice device;
  final BluetoothCharacteristic characteristic;

  const GamepadPage({ 
    super.key,
    required this.device,
    required this.characteristic
  });

  @override
  State<GamepadPage> createState() => _GamepadPageState();
}

class _GamepadPageState extends State<GamepadPage> {

  double xValue = 0.0;
  double yValue = 0.0;

  bool motorStarted = false;

  Future<void> updateMotor() async {
    await sendCommand(motorStarted ? 'stop_motor' : 'start_motor');
    setState(() { motorStarted = !motorStarted; });
  }

  Future<void> attack() async {
    await sendCommand('attack');
  }

  Future<void> dance() async {
    await sendCommand('dance');
  }

  Future<void> sendDrive() async {
    String direction = yValue >= 0.0 ? 'F' : 'B';
    double velocityOverall = yValue.abs() * 255.0;

    late int velocityLeft;
    late int velocityRight;

    if (xValue >= 0.0) {
      velocityLeft = (velocityOverall * (1.0 - xValue.abs())).round();
      velocityRight = velocityOverall.round();
    } else {
      velocityRight = (velocityOverall * (1.0 - xValue.abs())).round();
      velocityLeft = velocityOverall.round();
    }

    String leftSpeed = velocityLeft.toString().padLeft(3, '0');
    String rightSpeed = velocityRight.toString().padLeft(3, '0');

    await sendCommand('${direction}_${leftSpeed}_${direction}_$rightSpeed');
  }

  Future<void> sendCommand(String command) async {
    await widget.characteristic.write(
      CoreUtils.stringToBytes('$command|'), 
      withoutResponse: true
    );
  }

  Future<void> disconnectDevice() async {
    bool connectionError = false;
    await widget.device.disconnectAndUpdateStream().catchError((_) {
      CoreUtils.showToast(
        context,
        type: ToastType.error,
        title: 'Trennen fehlgeschlagen',
        description: 'Die Verbindung konnte nicht beendet werden.'
      );

      connectionError = true;
    });

    if (connectionError) return;

    if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).padding.left + UIConstants.defaultPadding,
              right: MediaQuery.of(context).padding.right + UIConstants.defaultPadding,
              top: MediaQuery.of(context).padding.top + 8.0,
              bottom: 8.0
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GamepadTopButton(
                  onPressed: () async => await disconnectDevice(),
                  color: Palette.gamepadTopButtonRed,
                  title: 'Beenden'
                ),
                GamepadTopButton(
                  onPressed: () async => await updateMotor(),
                  color: motorStarted
                    ? Palette.gamepadTopButtonYellow
                    : Palette.gamepadTopButtonGreen,
                  title: motorStarted
                    ? 'Motor stoppen'
                    : 'Motor starten'
                )
              ]
            )
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  YJoystick(
                    onChanged: (double newYValue) async {
                      yValue = newYValue;
                      await sendDrive();
                    }
                  ),
                  const SizedBox(width: 50.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GamepadActionButton(
                        onPressed: () async => await attack(),
                        icon: Icons.bolt_outlined
                      ),
                      const SizedBox(height: UIConstants.defaultPadding),
                      GamepadActionButton(
                        onPressed: () async => await dance(),
                        icon: Icons.flag_outlined
                      )
                    ]
                  ),
                  const SizedBox(width: 50.0),
                  XJoystick(
                    onChanged: (double newXValue) async {
                      xValue = newXValue;
                      await sendDrive();
                    }
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}