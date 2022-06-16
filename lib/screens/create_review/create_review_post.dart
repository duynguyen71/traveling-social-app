import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class CreateReviewPost extends StatefulWidget {
  const CreateReviewPost({Key? key}) : super(key: key);

  @override
  State<CreateReviewPost> createState() => _CreateReviewPostState();
}

class _CreateReviewPostState extends State<CreateReviewPost> {
  final HtmlEditorController _editorController = HtmlEditorController();

  @override
  void initState() {
    super.initState();
  }

  save() async {
    String text = await _editorController.getText();
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Create review post"),
              HtmlEditor(
                controller: _editorController,
                htmlToolbarOptions: HtmlToolbarOptions(
                  mediaUploadInterceptor: (p0, p1) {
                    return true;
                  },
                  defaultToolbarButtons: [
                    // StyleButtons(style: false),
                    const ParagraphButtons(
                        caseConverter: false,
                        decreaseIndent: false,
                        increaseIndent: false,
                        lineHeight: false,
                        textDirection: false),
                    const InsertButtons(
                      audio: false,
                      hr: false,
                      link: false,
                      otherFile: false,
                      table: false,
                      video: false,
                    ),
                    // OtherButtons(),
                  ],
                ),
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: "Your text here...",
                  initialText: "text content initial, if any",
                  spellCheck: true,
                ),
                otherOptions: const OtherOptions(
                  height: 400,
                ),
              ),
              TextButton(onPressed: save, child: const Text("SAVE"))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
