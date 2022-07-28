import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/setting/components/settting_item_leading.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';

class SettingItemWithMoreIcon extends StatelessWidget {
  const SettingItemWithMoreIcon(
      {Key? key,
      required this.isLast,
      required this.title,
      this.description,
      required this.onClick,
      required this.asset,
      this.leadingBg = Colors.black12,
      this.leadingColor = Colors.white})
      : super(key: key);

  final bool isLast;
  final String title;
  final String? description;
  final Function onClick;
  final String asset;
  final Color leadingBg, leadingColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onClick(),
        child: Ink(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SettingItemLeading(
                      asset: asset,
                      bg: leadingBg,
                      color: leadingColor,
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
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black54,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                !isLast ? const MyDivider() : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
