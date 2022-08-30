import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/screens/create_review/components/selected_tag.dart';
import 'package:traveling_social_app/widgets/my_text_icon_button.dart';
import 'package:traveling_social_app/widgets/tap_effect_widget.dart';
import 'package:provider/provider.dart';
import '../../models/tag.dart';
import '../../services/post_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickTagScreen extends StatefulWidget {
  const PickTagScreen({Key? key, required this.onSaveCallback})
      : super(key: key);

  @override
  State<PickTagScreen> createState() => _PickTagScreenState();

  static Route route({required Function callback}) => MaterialPageRoute(
        builder: (context) => PickTagScreen(onSaveCallback: callback),
      );

  final Function onSaveCallback;
}

class _PickTagScreenState extends State<PickTagScreen> {
  final _postService = PostService();
  final _tagEditController = TextEditingController();
  Set<Tag> _selectedTags = {};
  List<Tag> _tags = [];
  Timer? _debounce;

  @override
  void initState() {
    _selectedTags.addAll(context.read<CreateReviewPostCubit>().state.post.tags);
    super.initState();
  }

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _tagEditController.dispose();
    super.dispose();
  }

  _onChange(String? str) async {
    if (str == null || str.isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      // do something with query
      var tags =
          await _postService.getTags(pageSize: 20, page: 0, name: str.trim());
      setState(() {
        _tags = [Tag(name: str.trim()), ...tags];
      });
    });
  }

  _saveTags(BuildContext context) {
    context
        .read<CreateReviewPostCubit>()
        .updateReviewPost(tags: _selectedTags.toList());
    Navigator.pop(context);
  }

  _addTag(Tag tag) {
    setState(() {
      _selectedTags.add(tag.copyWith(status: 1));
      _tagEditController.clear();
    });
  }

  _removeTag(Tag e) {
    setState(() {
      _selectedTags = _selectedTags
          .map((t) => t.name == e.name ? e.copyWith(status: 0) : t)
          .toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context
            .read<CreateReviewPostCubit>()
            .updateReviewPost(tags: _selectedTags.toList());
        return Future(() => true);
      },
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  iconTheme: const IconThemeData(color: Colors.black54),
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: TextField(
                    decoration: InputDecoration(
                        hintText: "Nhập tên thẻ cần thêm vào bài",
                        hintStyle: TextStyle(color: Colors.black54)),
                    controller: _tagEditController,
                    onChanged: _onChange,
                  ),
                  actions: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyTextIconButton(
                            text: AppLocalizations.of(context)!.save,
                            bgColor: Colors.blueAccent,
                            icon: Icons.safety_check,
                            onTap: () => _saveTags(context)),
                      ),
                    )
                  ],
                )
              ];
            },
            body: Stack(
              alignment: Alignment.topCenter,
              fit: StackFit.expand,
              children: [
                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        runSpacing: 5.0,
                        spacing: 5.0,
                        children: _selectedTags
                            .map((e) => SelectedTag(
                                key: ValueKey(e),
                                tag: e,
                                remove: () {
                                  _removeTag(e);
                                }))
                            .toList(),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var tag = _tags[index];
                        return TapEffectWidget(
                          tap: () {
                            _addTag(tag);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                // color: Colors.grey.shade200,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1))),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10.0),
                            // margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(tag.name.toString()),
                          ),
                        );
                      },
                      itemCount: _tags.length,
                    )
                  ],
                ),
                // Positioned(child: Container(child: Text('add tag'),),top: 0,)
              ],
            )),
      ),
    );
  }
}
