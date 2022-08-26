import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';

class SettingItemSelected extends StatelessWidget {
  const SettingItemSelected(
      {Key? key,
      required this.text,
      this.isChecked = false,
      required this.onClick})
      : super(key: key);

  final String text;
  final bool isChecked;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Ink(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    isChecked
                        ? const Icon(Icons.check)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const MyDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
