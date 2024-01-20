// import 'dart:io'
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> showAlert(
    {required BuildContext context,
    required String title,
    required String message,
    required String buttonText,
    required Function onPressed}) async {
  if (Platform.isIOS) {
    return await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: Text(buttonText),
                  onPressed: () => onPressed(),
                )
              ],
            ));
  }

  return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              FilledButton(onPressed: () => onPressed, child: Text(buttonText))
            ],
          ));
}
