import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/home/home_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/post_viewmoel.dart';
import 'package:traveling_social_app/widgets/media_file_container.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../services/post_service.dart';
import '../../widgets/loading_widget.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostService _postService = PostService();
  final _imagePicker = ImagePicker();
  List<XFile>? _xFiles = [];
  final List<File> _pickedFiles = [];
  final _captionController = TextEditingController();
  bool _isLoading = false;

  _handleAddPost() async {
    ApplicationUtility.hideKeyboard();
    isLoading = true;
    if (_captionController.text.toString().isEmpty && _pickedFiles.isEmpty) {
      return;
    }
    Map<String, dynamic> post = {};
    post['caption'] = _captionController.text.toString();
    post['type'] = 1;

    try {
      final resp = await _postService.createPost(post, _pickedFiles);
      context.read<PostViewModel>().addPost(resp);
      ApplicationUtility.pushAndReplace(context, const HomeScreen());
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
            leadingWidth: 80,
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  _handleAddPost();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(5)),
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
            padding: const EdgeInsets.only(top: 70),
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
                          const SizedBox(height: 5),
                          //MEDIA FILES
                          SizedBox(
                            width: size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                  children: List.generate(_pickedFiles.length,
                                      (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MediaFileContainer(
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
                                  ),
                                );
                              })),
                            ),
                          )
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
                      )
                    ],
                  ),
                ),
                // MediaQuery.of(context).viewInsets.bottom > 0
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? Positioned(
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(
                                color: Colors.grey.shade300,
                                width: .5,
                              ))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    _xFiles =
                                        await _imagePicker.pickMultiImage();
                                    if (_xFiles != null &&
                                        _xFiles!.isNotEmpty) {
                                      setState(() {
                                        _pickedFiles.addAll(_xFiles!
                                            .map((e) => File(e.path))
                                            .toList());
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.photo_album_outlined,
                                    color: Colors.black87,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    XFile? xFile = await _imagePicker.pickImage(
                                        source: ImageSource.camera);
                                    if (xFile != null) {
                                      setState(() {
                                        _pickedFiles.add(File(xFile.path));
                                      });
                                    }
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
                                  ))
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
}
