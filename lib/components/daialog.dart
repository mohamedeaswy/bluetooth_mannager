import 'package:flutter/material.dart';

SnackBar snackBar({required String msg, required BuildContext context}) =>
    SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );

showLoaderDialog(BuildContext context) {
  AlertDialog alert = const AlertDialog(
    content: Center(
      child: CircularProgressIndicator(),
    ),
    backgroundColor: Colors.black26,
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => false,
          child: SizedBox(width: 200, height: 200, child: alert));
    },
  );
}
// ScaffoldMessenger.of(context).showSnackBar(snackBar);

