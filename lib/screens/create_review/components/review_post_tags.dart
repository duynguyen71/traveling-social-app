import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/tap_effect_widget.dart';

import '../../../models/tag.dart';

class ReviewPostTags extends StatelessWidget {
  const ReviewPostTags({Key? key, required this.tags, required this.onTap})
      : super(key: key);
  final List<Tag> tags;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return tags.isEmpty
        ? const SizedBox.shrink()
        : Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  "Tags:",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var tag = tags[index];
                      return TapEffectWidget(
                        tap: () => onTap(tag),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.tag,
                                size: 14,
                                color: Colors.blueGrey,
                              ),
                              Text(tag.name!,
                                  style: const TextStyle(
                                      color: Colors.blueGrey, fontSize: 14))
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: tags.length,
                  ),
                ),
              ),
            ],
          );
  }
}
