import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoAlertDialog(
      title: Text("Delete Post"),
      content: Text("Are you sure you want to delete this Post"),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Yes"),
        ),
        CupertinoDialogAction(
          child: Text("Cancel"),
        )
      ],
    );
  }
}
