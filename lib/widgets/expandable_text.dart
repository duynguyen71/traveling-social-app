import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpandableText = false;

  @override
  void initState() {
    if (widget.text.length > 30) {
      setState(() {
        isExpandableText = true;
      });
    } else {
      setState(() {
        isExpandableText = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: const TextStyle(color: Colors.white),
          maxLines: isExpandableText ? 2 : null,
          overflow: isExpandableText ? TextOverflow.ellipsis : null,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpandableText = !isExpandableText;
            });
          },
          child: Text(
            isExpandableText ? "Show more" : "Show less",
            style: TextStyle(color: Colors.blueGrey),
          ),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft),
        ),
      ],
    );
  }
}
