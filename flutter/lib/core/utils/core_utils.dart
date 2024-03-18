import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:toastification/toastification.dart';

import 'package:arducon/core/res/theme/palette.dart';
import 'package:arducon/core/utils/enums/toast_type.dart';
import 'package:arducon/core/utils/constants/ui_constants.dart';

abstract class CoreUtils {

  const CoreUtils();

  static void postFrameCall(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void showToast(
    BuildContext context, 
  { 
    required ToastType type,
    required String title,
    required String description
  }) {
    postFrameCall(() {
      toastification.show(
        context: context,
        type: type.toastificationType,
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        primaryColor: Palette.toastForeground,
        foregroundColor: Palette.toastForeground,
        backgroundColor: type.backgroundColor,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Expletus_Sans',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Palette.toastForeground
          )
        ),
        description: Text(
          description,
          style: const TextStyle(
            fontFamily: 'Hind',
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Palette.toastForeground
          )
        ),
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3)
      );
    });
  }

  static List<int> stringToBytes(String text) {
    List<int> bytes = [];

    for (int i = 0; i < text.length; i++) {
      int codeUnit = text.codeUnitAt(i);
      
      if (codeUnit > 255) codeUnit = 255;

      bytes.add(codeUnit);
    }

    return bytes;
  }
}