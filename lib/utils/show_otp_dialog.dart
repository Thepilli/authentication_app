import 'package:authentication_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Enter OTP code below:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [CustomTextField(controller: codeController, hintText: "Received OPT code")],
      ),
      actions: [TextButton(onPressed: onPressed, child: const Text('Done'))],
    ),
  );
}
