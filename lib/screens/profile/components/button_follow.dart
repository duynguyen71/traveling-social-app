import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';

class ButtonFollow extends StatefulWidget {
  const ButtonFollow({Key? key, required this.uid, required this.username})
      : super(key: key);

  final String uid;
  final String username;

  @override
  _ButtonFollowState createState() => _ButtonFollowState();
}

class _ButtonFollowState extends State<ButtonFollow> {
  bool followed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: followed ? kPrimaryLightColor : Colors.white,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        splashColor: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          if (followed) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Are you sure unfollow ${widget.username}"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            handleFollowBtnClick(context);
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ],
                  );
                });
          } else {
            handleFollowBtnClick(context);
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              style: BorderStyle.solid,
              color: followed ? kPrimaryLightColor : Colors.white,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                followed ? "Following" : "Follow",
                style: TextStyle(
                  color: !followed ? kPrimaryLightColor : Colors.white,
                ),
              ),
              Icon(
                Icons.add,
                size: 15,
                color: !followed ? kPrimaryLightColor : Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleFollowBtnClick(BuildContext context) {}
}
