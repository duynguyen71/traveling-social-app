import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';

class MyBottomDialog extends StatelessWidget {
  const MyBottomDialog({Key? key, required this.items}) : super(key: key);

  final List<BottomDialogItem> items;

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
                            child: SizedBox(
                              // padding: const EdgeInsets.symmetric(vertical: 5),
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
            // padding: const EdgeInsets.all(5),
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

class BottomDialogItem {
  String title;

  Function onClick;

  BottomDialogItem({required this.title, required this.onClick});
}
