import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {bool showDismiss})
  => ScaffoldMessenger.of(context).showSnackBar(
    showDismiss
     ? SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      )
    : SnackBar(
      content: Text(text),
    )
  );