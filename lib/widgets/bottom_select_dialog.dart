import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';

class BottomSelectDialog extends StatelessWidget {
  const BottomSelectDialog({Key? key, required this.items}) : super(key: key);

  final List<SelectItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(10),
            // padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(items.length, (index) {
                  var item = items[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            item.onClick();
                            Navigator.of(context).pop();
                          },
                          child: Ink(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: double.infinity,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                onPressed: null,
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      (index + 1) == items.length
                          ? const SizedBox.shrink()
                          : const SizedBox(child: MyDivider()),
                    ],
                  );
                })
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red[300])),
            ),
          )
        ],
      ),
    );
  }
}

class SelectItem {
  String title;

  Function onClick;

  SelectItem({required this.title, required this.onClick});
}
