import 'package:flutter/cupertino.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Notification"),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text("OK"),
          isDefaultAction: true,
        )
      ],
    );
  }
}
