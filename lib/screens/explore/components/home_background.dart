import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({Key? key, required this.child, required this.isLoading})
      : super(key: key);
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: double.infinity,
      width: size.width,
      child: Stack(
        children: [child, LoadingWidget(isLoading: isLoading)],
      ),
    );
  }
}
