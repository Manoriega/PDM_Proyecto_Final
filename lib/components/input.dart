import 'package:flutter/material.dart';
import 'package:pokimon/components/error_text.dart';

Widget Input(
    BuildContext context,
    bool obscuretxt,
    bool autocorrect,
    bool sugestions,
    TextEditingController controller,
    String placeholder,
    String errors) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          obscureText: obscuretxt,
          autocorrect: autocorrect,
          enableSuggestions: sugestions,
          controller: controller,
          decoration: InputDecoration(
              enabledBorder: Theme.of(context).inputDecorationTheme.border,
              labelText: placeholder),
        ),
      ),
      ErrorText(errors, context)
    ],
  );
}
