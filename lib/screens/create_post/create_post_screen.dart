import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveling_social_app/services/navigation_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/current_user_post_view_model.dart';
import 'package:traveling_social_app/view_model/post_view_model.dart';
import 'package:traveling_social_app/widgets/bottom_select_dialog.dart';
import 'package:traveling_social_app/widgets/media_file_container.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../services/post_service.dart';
import '../../widgets/loading_widget.dart';
import 'components/user_draft_posts.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostService _postService = PostService();
  final _imagePickerQty = 60;
  final _imagePicker = ImagePicker();
  final List<File> _pickedFiles = [];
  final _captionController = TextEditingController();
  bool _isLoading = false;
  bool _isCaptionEmpty = true;
  final FocusNode _focusNode = FocusNode();

  _handleAddPost() async {
    //check post valid
    if (_isCaptionEmpty && _pickedFiles.isEmpty) {
      return;
    }
    ApplicationUtility.hideKeyboard();
    isLoading = true;
    Map<String, dynamic> post = {};
    post['caption'] = _captionController.text.toString();
    post['type'] = 1;
    post['status'] = 1;
    try {
      final resp = await _postService.createPost(post, _pickedFiles);
      context.read<PostViewModel>().addPost(resp);
      context.read<CurrentUserPostViewModel>().addPost(resp);
      // ApplicationUtility.pushAndReplace(context, const HomeScreen());
      Navigator.pop(context);
    } catch (e) {
      print("Failed to create post :" + e.toString());
    } finally {
      isLoading = false;
    }
  }

  set isLoading(bool l) {
    setState(() {
      _isLoading = l;
    });
  }

  @override
  void initState() {
    super.initState();
    s.add(BottomDialogItem(
        title: 'Delete',
        onClick: () {
          _focusNode.unfocus();
          discard();
        }));
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: TextButton(
              onPressed: _handleCancelPress,
              child: const Text(
                'Cancel',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal),
              ),
            ),
            leadingWidth: 80,
            elevation: 0,
            actions: [
              (!_isCaptionEmpty || _pickedFiles.isNotEmpty)
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: _showDrafts,
                      child: const Tooltip(
                        message: "Choose your previous drafts",
                        waitDuration: Duration(seconds: 1),
                        showDuration: Duration(seconds: 2),
                        padding: EdgeInsets.all(12),
                        height: 35,
                        preferBelow: true,
                        child: Text(
                          'Drafts',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
              TextButton(
                onPressed: () {
                  _handleAddPost();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                      color: (_isCaptionEmpty && _pickedFiles.isEmpty)
                          ? Colors.blueAccent.withOpacity(.5)
                          : Colors.blueAccent,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.white.withOpacity(.8),
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 100, left: 10),
            width: double.infinity,
            height: size.height,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            margin: EdgeInsets.zero,
                            child: TextField(
                              focusNode: _focusNode,
                              onChanged: (value) {
                                if (value.isEmpty && !_isCaptionEmpty) {
                                  setState(() {
                                    _isCaptionEmpty = true;
                                  });
                                } else {
                                  if (value.isNotEmpty && _isCaptionEmpty) {
                                    setState(() {
                                      _isCaptionEmpty = false;
                                    });
                                  }
                                }
                              },
                              controller: _captionController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 18),
                              showCursor: true,
                              cursorColor: Colors.blue,
                              decoration: const InputDecoration(
                                hintText: 'What are you thinking?',
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          //END OF INPUT CONTAINER
                          const SizedBox(height: 5),
                          //MEDIA FILES
                          _pickedFiles.isNotEmpty
                              ? SizedBox(
                                  height: 180,
                                  child: ReorderableListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    onReorder: ((oldIndex, newIndex) {
                                      if (newIndex > oldIndex) {
                                        newIndex = newIndex - 1;
                                      }
                                      final element =
                                          _pickedFiles.removeAt(oldIndex);
                                      _pickedFiles.insert(newIndex, element);
                                    }),
                                    itemBuilder: (context, index) {
                                      return MediaFileContainer(
                                        key: ValueKey(_pickedFiles[index]),
                                        ratio: 16 / 9,
                                        boxFit: BoxFit.fitHeight,
                                        file: _pickedFiles[index],
                                        height: 180,
                                        onClick: () {
                                          setState(() {
                                            _pickedFiles.removeAt(index);
                                          });
                                        },
                                        width: null,
                                        modifiedFile: (File f) {
                                          setState(() {
                                            _pickedFiles[index] = f;
                                          });
                                        },
                                      );
                                    },
                                    itemCount: _pickedFiles.length,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.blue,
                            ),
                            Text(
                              'Add location',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //IMAGE SELECTED

                // MediaQuery.of(context).viewInsets.bottom > 0
                MediaQuery.of(context).viewInsets.bottom > 0
                    ? Positioned(
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.shade300,
                                width: .5,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              //PICK IMAGES FROM GALLERY
                              IconButton(
                                onPressed: () async {
                                  List<XFile>? xFiles =
                                      await _imagePicker.pickMultiImage(
                                          imageQuality: _imagePickerQty);
                                  if (xFiles != null && xFiles.isNotEmpty) {
                                    for (int i = 0; i < xFiles.length; i++) {
                                      File? file = await ApplicationUtility
                                          .compressImage(xFiles[0].path,
                                              quality: 20);
                                      setState(() {
                                        _pickedFiles.add(file!);
                                      });
                                    }
                                  }
                                  _focusNode.requestFocus();
                                },
                                icon: const Icon(
                                  Icons.photo_album_outlined,
                                  color: Colors.black87,
                                ),
                              ),
                              //PICK IMAGES FROM CAMERA
                              IconButton(
                                  onPressed: () async {
                                    XFile? xFile = await _imagePicker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: _imagePickerQty);
                                    if (xFile != null) {
                                      setState(() {
                                        _pickedFiles.add(File(xFile.path));
                                      });
                                    }
                                    _focusNode.requestFocus();
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.black87,
                                  )),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ),
                        ),
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        LoadingWidget(isLoading: _isLoading)
      ],
    );
  }

  _showDrafts() async {
    ApplicationUtility.showModelBottomDialog(context, const UserDraftPosts());
  }

  discard() async {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    Navigator.of(context).pop();
  }

  List<BottomDialogItem> s = [
    BottomDialogItem(title: 'Save as draft', onClick: () {}),
  ];

  _handleCancelPress() {
    ApplicationUtility.showModelBottomDialog(
      NavigationService.navigatorKey.currentContext!,
      MyBottomDialog(
        items: s,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _captionController.dispose();
    super.dispose();
  }
}