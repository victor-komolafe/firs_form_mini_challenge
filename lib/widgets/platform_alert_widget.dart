import 'dart:io';

import 'package:firs_mini_project/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlert {
  final String title;
  final String message;
  const PlatformAlert({required this.title, required this.message});

  void show(BuildContext context) {
    if (Platform.isAndroid) {
      _buildMaterialAlert(context);
    } else if (Platform.isIOS) {
      _buildCupertinoAlert(context);
    }
  }

  void _buildMaterialAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: ConstantFonts.inter,
            ),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(
                    'Close',
                    style: ConstantFonts.inter,
                  ))
            ],
          );
        });
  }

  void _buildCupertinoAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Close '))
            ],
          );
        });
  }
}
