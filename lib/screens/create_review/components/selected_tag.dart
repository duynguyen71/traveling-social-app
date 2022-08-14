import 'package:flutter/material.dart';

import '../../../models/tag.dart';

class SelectedTag extends StatelessWidget {
  const SelectedTag({Key? key, required this.tag, required this.remove}) : super(key: key);
  final Tag tag;
  final Function remove;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.green),
            alignment: Alignment.center,
            child: Text(tag.name!),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed:()=> remove(),
                    icon: const Icon(Icons.close),
                    iconSize: 14,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
