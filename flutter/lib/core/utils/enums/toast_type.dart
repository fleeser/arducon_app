import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

import 'package:arducon/core/res/theme/palette.dart';

enum ToastType {
  success(
    toastificationType: ToastificationType.success,
    backgroundColor: Palette.toastSuccessBackground
  ),
  error(
    toastificationType: ToastificationType.error,
    backgroundColor: Palette.toastErrorBackground
  ),
  warning(
    toastificationType: ToastificationType.warning,
    backgroundColor: Palette.toastWarningBackground
  ),
  info(
    toastificationType: ToastificationType.info,
    backgroundColor: Palette.toastInfoBackground
  );

  final ToastificationType toastificationType;
  final Color backgroundColor;

  const ToastType({
    required this.toastificationType,
    required this.backgroundColor
  });
}