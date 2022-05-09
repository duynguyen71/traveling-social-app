import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/comment_entry.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(.1),
        body: Container(
          height: size.height,
          // alignment: Alignment.bottomCenter,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey.withOpacity(.1),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  height: size.height - 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children:  [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Comments",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                        ...List.generate(20, (index) => Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 8.0,vertical: 10),
                          child: const CommentEntry(),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
