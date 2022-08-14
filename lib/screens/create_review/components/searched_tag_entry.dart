import 'package:flutter/material.dart';

class SearchedTagEntry extends StatelessWidget {
  const SearchedTagEntry({Key? key, required this.onTap}) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text('name'),
        ],
      ),
    );
  }
}
