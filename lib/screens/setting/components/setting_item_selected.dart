import 'package:flutter/material.dart';

class SettingItemSelected extends StatelessWidget {
  const SettingItemSelected(
      {Key? key, required this.text, this.isChecked = false})
      : super(key: key);

  final String text;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
            child: Row(
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                isChecked ? const Icon(Icons.check) : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
