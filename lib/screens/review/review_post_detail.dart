import 'package:flutter/material.dart';

class ReviewPostDetailScreen extends StatefulWidget {
  const ReviewPostDetailScreen({Key? key,required this.id}) : super(key: key);

  final int id;

  @override
  State<ReviewPostDetailScreen> createState() => _ReviewPostDetailScreenState();
}

class _ReviewPostDetailScreenState extends State<ReviewPostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(

        ),
      ),
    );
  }
}
