import 'package:flutter/material.dart';

SnackBar snackBar({required String msg, required BuildContext context}) =>
    SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
// ScaffoldMessenger.of(context).showSnackBar(snackBar);

