import 'package:flutter/material.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/explore/components/post_entry.dart';
import 'package:traveling_social_app/screens/profile/components/profile_cover_background.dart';
import '../../models/post.dart';
import '../../models/Review_post_report.dart';
import '../../my_theme.dart';
import '../../services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/user_file_upload_grid.dart';

class CurrentUserProfileScreen extends StatefulWidget {
  const CurrentUserProfileScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();

  static Route route() =>
      MaterialPageRoute(builder: (_) => const CurrentUserProfileScreen());
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  List<Post> _posts = [];

  @override
  void initState() {
    _postService
        .getCurrentUserPosts(page: 0, pageSize: 10, status: 1)
        .then((value) => setState(() => _posts = value));
    // _postService
    //     .getCurrentUserReviewPosts()
    //     .then((value) => setState(() => _reviewPosts = value));
    // _postService.getUserFileUploads(context.read<AuthenticationBloc>().state.user.id).then((value) => );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize:const Size.fromHeight(40),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       border: Border(
      //         bottom: BorderSide(color: Colors.grey.shade200),
      //       ),
      //     ),
      //     child: AppBar(
      //       elevation: 0,
      //       centerTitle: false,
      //       backgroundColor: Colors.white,
      //       title: Text("Nguyen Khanh Duy"),
      //       actions: [
      //         IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_outlined))
      //       ],
      //     ),
      //   ),
      // ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const ProfileCoverBackground(),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ];
            },
            body: Column(
              mainAxisSize: MainAxisSize.min,
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
                          return PostEntry(post: post);
                        },
                        itemCount: _posts.length,
                        padding: EdgeInsets.zero,
                      ),
                      UserFileUploadGrid(
                          userId:
                              context.read<AuthenticationBloc>().state.user.id),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
