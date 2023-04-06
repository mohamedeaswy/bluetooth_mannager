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
  AlertDialog alert =  AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        Center(
          child: OutlinedButton(onPressed: (){
            // if (context.mounted) {
            Navigator.of(context, rootNavigator: false).pop();
            // }
          }, child: const Text('Stop')),
        ),

      ],
    ),
    backgroundColor: Colors.white38,

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

