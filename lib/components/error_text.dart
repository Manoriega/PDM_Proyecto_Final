import 'package:flutter/material.dart';

Text ErrorText(String errors, BuildContext context) {
  return Text(
    errors,
    style: TextStyle(color: Theme.of(context).errorColor),
  );
}
