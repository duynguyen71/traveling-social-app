import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/setting/components/settting_item_leading.dart';

class SettingItemCheckBox extends StatelessWidget {
  const SettingItemCheckBox(
      {Key? key,
      required this.isLast,
      required this.title,
      this.description,
      required this.onChange,
      required this.leadingBg,
      this.value = false})
      : super(key: key);
  final bool isLast;
  final String title;
  final String? description;
  final Color leadingBg;
  final Function onChange;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Ink(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Icon(Icons.security),
                const SettingItemLeading(
                  asset: 'assets/icons/dark-mode.svg',
                  bg: Colors.redAccent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      description != null
                          ? Text(
                              description!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                const Spacer(),
                Transform.scale(
                  scale: .8,
                  child: CupertinoSwitch(
                    onChanged: (value) {
                      onChange(value);
                    },
                    value: value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
