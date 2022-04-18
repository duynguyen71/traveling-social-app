import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.isLoading}) : super(key: key);

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
              child: const Align(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
