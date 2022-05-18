import 'package:flutter/material.dart';

class MyPopupMenuItem extends StatelessWidget {
  const MyPopupMenuItem({Key? key, required this.title, required this.iconData})
      : super(key: key);

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
          Icon(
            iconData,
            size: 18,
            color: Colors.black54,
          ),

        ],
      ),
    );
  }
}
