import 'package:flutter/cupertino.dart';

class SearchResultListContainer extends StatelessWidget {
  const SearchResultListContainer(
      {Key? key,
      this.list = const [],
      required this.child,
      required this.isLoading})
      : super(key: key);

  final List<dynamic> list;
  final Widget Function(dynamic c) child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: CupertinoActivityIndicator()),
                )
              : const SizedBox.shrink();
        }
        var dynamic = list[index];
        return child(dynamic);
      },
      itemCount: list.length + 1,
      shrinkWrap: true,
    );
  }
}
