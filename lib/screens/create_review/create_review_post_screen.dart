import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/screens/create_review/components/review_post_editor.dart';
import 'package:traveling_social_app/screens/create_review/components/editor_review.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:traveling_social_app/widgets/loading_widget.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme_constants.dart';
import '../../my_theme.dart';
import '../../services/post_service.dart';

class CreateReviewPostScreen extends StatefulWidget {
  const CreateReviewPostScreen({Key? key}) : super(key: key);

  @override
  State<CreateReviewPostScreen> createState() => _CreateReviewPostScreenState();
}

class _CreateReviewPostScreenState extends State<CreateReviewPostScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late quill.QuillController _controller;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrevData();
  }

  _loadPrevData() {
    var review = context.read<CreateReviewPostCubit>().state.post;
    var title = review.title;

    if (title == null || review.contentJson == null) {
      print('crete new data');
      _controller = quill.QuillController.basic();
      _titleController.text = lorem(words: 10, paragraphs: 1);
      _controller.document.insert(0, lorem(words: 100, paragraphs: 4));
    } else {
      print('load prec data');
      var decoded = jsonDecode(review.contentJson!);
      _controller = quill.QuillController(
          document: quill.Document.fromJson(decoded),
          selection: const TextSelection.collapsed(offset: 0));
      _titleController.text = title.toString();
      // _controller.document.insert(0, review.contentJson);
    }
  }

  _changeToViewMode() {
    ApplicationUtility.hideKeyboard();
    var json = jsonEncode(_controller.document.toDelta().toJson());
    context
        .read<CreateReviewPostCubit>()
        .updateReviewPost(contentJson: json, title: _titleController.text);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return EditorReview(controller: _controller);
        },
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () {
        _updateReviewPostState(context);
        return Future.value(true);
      },
      child: Scaffold(
        // backgroundColor: Colors.white12,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            NestedScrollView(
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ReviewPostEditor(
                      controller: _controller,
                      titleController: _titleController),
                ],
              ),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  BaseSliverAppBar(
                    elevation: 0,
                    forceElevated: true,
                    title: 'Review post',
                    actions: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedIconButton(
                            onClick: _handleUploadPost,
                            icon: Icons.save,
                            size: 30,
                            bgColor: Colors.blue,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedIconButton(
                              onClick: _changeToViewMode,
                              icon: Icons.visibility,
                              size: 30),
                        ),
                      ),
                    ],
                  ),
                  SliverPersistentHeader(
                    delegate: PersistentHeader(widget: _toolbar(_controller)),
                    pinned: true,
                  )
                ];
              },
            ),
            BlocBuilder<CreateReviewPostCubit, CreateReviewPostState>(
              builder: (context, state) {
                return LoadingWidget(
                    isLoading:
                        state.status == ReviewPostStatus.uploadingReview);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateReviewPostState(BuildContext context) {
    var document = _controller.document;
    context.read<CreateReviewPostCubit>().updateReviewPost(
        title: _titleController.text.toString(),
        contentJson: jsonEncode(document.toDelta().toJson()),
        content: document.toPlainText());
  }

  _handleUploadPost() async {
    _updateReviewPostState(context);
    await context.read<CreateReviewPostCubit>().uploadReview();
    Navigator.pop(context);
  }

  quill.QuillToolbar _toolbar(quill.QuillController controller) {
    return quill.QuillToolbar.basic(
      controller: controller,
      multiRowsDisplay: false,
      showAlignmentButtons: true,
      toolbarIconSize: 20,
      // multiRowsDisplay: true,
      showDividers: true,
      showFontFamily: false,
      showFontSize: false,
      showBoldButton: true,
      showItalicButton: true,
      showSmallButton: false,
      showUnderLineButton: true,
      showStrikeThrough: false,
      showInlineCode: false,
      showColorButton: false,
      showBackgroundColorButton: false,
      showClearFormat: true,
      showLeftAlignment: true,
      showCenterAlignment: true,
      showRightAlignment: true,
      showJustifyAlignment: true,
      showHeaderStyle: true,
      showListNumbers: true,
      showListBullets: true,
      showListCheck: false,
      showCodeBlock: false,
      showQuote: true,
      showIndent: false,
      showLink: true,
      showUndo: false,
      showRedo: false,
      showImageButton: false,
      showVideoButton: false,
      showFormulaButton: false,
      showCameraButton: true,
      showDirection: false,
      showSearchButton: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 56.0,
      child: Center(child: widget),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
