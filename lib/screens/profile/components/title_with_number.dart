import 'package:flutter/cupertino.dart';

class TitleWithNumber extends StatelessWidget {
  const TitleWithNumber({Key? key, required this.title, required this.number}) : super(key: key);

  final String title;
  final int number;
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
          title,
            style: const TextStyle(
              // color: Colors.white,
              // fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
           number.toString(),
            style: const TextStyle(
              // color: Colors.white,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
