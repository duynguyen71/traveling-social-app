import 'package:flutter/material.dart';

class MyPopupMenuItem extends StatelessWidget {
  const MyPopupMenuItem(
      {Key? key, required this.title, required this.iconData, this.color})
      : super(key: key);

  final String title;
  final IconData iconData;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      constraints: const BoxConstraints(minWidth: 100.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color ?? Colors.grey.withOpacity(.1),
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
          const SizedBox(width: 10),
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
