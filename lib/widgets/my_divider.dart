import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key, this.color,  this.width}) : super(key: key);
  final Color? color;
  final double? width;
  @override
  Widget build(BuildContext context) {
  return  Container(
      decoration:  BoxDecoration(
        border: Border(
          bottom: BorderSide(color:color?? Colors.lightGreen,width:width?? 3.0),
        ),
      ),
    );
  }
}
