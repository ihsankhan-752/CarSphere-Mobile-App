import 'package:flutter/material.dart';

void showCustomMsg({
  required BuildContext context,
  required String msg,
  Color? bgColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: bgColor ?? Colors.green),
  );
}
