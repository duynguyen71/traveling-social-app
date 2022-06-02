import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;

class ReviewPostDetailScreen extends StatefulWidget {
  const ReviewPostDetailScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ReviewPostDetailScreen> createState() => _ReviewPostDetailScreenState();
}

class _ReviewPostDetailScreenState extends State<ReviewPostDetailScreen> {
  String htmlData =
  """<img alt='Alt Text of an intentionally broken image' src='https://images.pexels.com/photos/235615/pexels-photo-235615.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'/>""";
  late dom.Document doc;

  @override
  void initState() {
    super.initState();
    doc = htmlparser.parse(htmlData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Html.fromDom(document: doc),
      ),
    );
  }
}
