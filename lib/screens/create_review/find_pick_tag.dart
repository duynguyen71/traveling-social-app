import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/app_theme_constants.dart';
import '../../models/tag.dart';
import '../../services/post_service.dart';
import '../../widgets/my_text_icon_button.dart';
import '../../widgets/tap_effect_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/selected_tag.dart';

class FindPickTag extends StatefulWidget {
  const FindPickTag({Key? key, required this.initialTags, required this.onSave})
      : super(key: key);

  @override
  State<FindPickTag> createState() => _FindPickTagState();
  final List<Tag> initialTags;
  final Function(List<Tag> tags) onSave;
}

class _FindPickTagState extends State<FindPickTag> {
  final _postService = PostService();
  final _tagEditController = TextEditingController();
  Set<Tag> _selectedTags = {};
  List<Tag> _tags = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedTags = {...widget.initialTags};
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
    return DraggableScrollableSheet(
      initialChildSize: .9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: Colors.white,
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        title: Container(
                          color: Colors.transparent,
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: TextField(
                            style: const TextStyle(
                                color: kPrimaryColor, fontSize: 14),
                            keyboardType: TextInputType.multiline,
                            textAlign: TextAlign.left,
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onChanged: _onChange,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              isCollapsed: true,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: const EdgeInsets.all(8.0),
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                              hintText: "Nhập tên thẻ cần tìm...",
                            ),
                          ),
                        ),
                        actions: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MyTextIconButton(
                                  text: AppLocalizations.of(context)!.save,
                                  bgColor: Colors.blueAccent,
                                  icon: Icons.safety_check,
                                  onTap: () =>
                                      widget.onSave([..._selectedTags])),
                            ),
                          )
                        ],
                      )
                    ];
                  },
                  body: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      //SELECTED TAGS
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            children: _selectedTags
                                .map(
                                  (e) => e.status == 0
                                      ? const SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SelectedTag(
                                            tag: e,
                                            remove: () => _removeTag(e),
                                          ),
                                        ),
                                )
                                .toList(),
                          ),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
