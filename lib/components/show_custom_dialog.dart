import 'package:flutter/material.dart';

Future<dynamic> ShowCustomDialog(BuildContext context, Widget dialog) {
  return showDialog(
      context: context,
      builder: (context) {
        return dialog;
      });
}
