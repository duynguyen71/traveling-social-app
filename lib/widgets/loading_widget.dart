import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.isLoading}) : super(key: key);

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Positioned.fill(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.04)),
                child: const Align(
                  child: CupertinoActivityIndicator(),
                  alignment: Alignment.center,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
