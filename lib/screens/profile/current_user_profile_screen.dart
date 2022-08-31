import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/explore/components/post_entry.dart';
import 'package:traveling_social_app/screens/profile/components/current_user_profile_header.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

import '../../models/post.dart';
import '../../my_theme.dart';
import '../../services/post_service.dart';

class CurrentUserProfileScreen extends StatefulWidget {
  const CurrentUserProfileScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();

  static Route route() =>
      MaterialPageRoute(builder: (_) => const CurrentUserProfileScreen());
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen>
    with AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  List<Post> _posts = [];
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchPost();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        var position = _scrollController.position;
        if (position.pixels == position.maxScrollExtent) {
          _fetchPost();
        }
      });
    });
  }

  bool _isLoading = false;
  int _page = 0;
  bool _hasReachMax = false;

  _fetchPost() async {
    if (_isLoading || _hasReachMax) return;
    try {
      setState(() => _isLoading = true);
      var post = await _postService.getCurrentUserPosts(
          page: _page, pageSize: 5, status: 1);
      setState(() {
        _posts.addAll(post);
        _isLoading = false;
        _hasReachMax = post.isEmpty;
        _page = post.isEmpty ? _page : (_page + 1);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasReachMax = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const CurrentUserProfileHeader(),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ];
            },
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Material(
                  color: Colors.white,
                  child: TabBar(
                    isScrollable: false,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.black54,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: kPrimaryColor,
                    indicatorPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    labelStyle: MyTheme.heading2.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.grid_on_outlined),
                      ),
                      Tab(
                        icon: Icon(Icons.image),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          var post = _posts[index];
                          return PostEntry(
                            post: post,
                            onTapMoreIcon: () =>
                                _showActionModalPopup(post.id!),
                          );
                        },
                        itemCount: _posts.length,
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                      ),
                      Container(),
                      // UserFileUploadGrid(
                      //     userId:
                      //         context.read<AuthenticationBloc>().state.user.id),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _showActionModalPopup(int postId) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('Bạn có chắc muốn xóa bài viết này?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Xóa'),
                            onPressed: () {
                              setState(() {
                                _posts.removeWhere(
                                    (element) => element.id == postId);
                                _postService.hidePost(postId: postId);
                              });
                              Navigator.pop(context);
                              ApplicationUtility.showSuccessToast(
                                  AppLocalizations.of(context)!
                                      .removePostSuccess);
                            },
                            isDestructiveAction: true,
                          ),
                          CupertinoDialogAction(
                            child: const Text('Hủy'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop("Hủy");
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Xóa'))
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Hủy");
            },
            isDefaultAction: true,
            child: const Text(
              'Hủy',
            ),
          ),
          // title: const Text('duy nguyen posts'),
        );
      },
    );
  }

  // void showHidePostAlert( int postId) {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext dialogContext) {
  //       return CupertinoAlertDialog(
  //         title: const Text("Thông báo"),
  //         content: const Text("Bạn có chắc muốn xóa bài này?"),
  //         actions: <Widget>[
  //           CupertinoDialogAction(
  //             child: const Text("Hủy"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: const Text("Xóa",
  //                 style: TextStyle(color: Colors.redAccent)),
  //             onPressed: () {
  //               context.read<PostBloc>().add(RemovePost(postId));
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  bool get wantKeepAlive {
    return false;
  }
}
