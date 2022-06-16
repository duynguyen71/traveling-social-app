
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/models/post.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/view_model/post_view_model.dart';


class UserDraftPosts extends StatefulWidget {
  const UserDraftPosts({Key? key}) : super(key: key);

  @override
  State<UserDraftPosts> createState() => _UserDraftPostsState();
}

class _UserDraftPostsState extends State<UserDraftPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: Consumer<PostViewModel>(
          builder: (context, value, child) {
            Set<Post> drafts = value.posts;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "Drafts (${drafts.length})",
                    style: const TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .6,
                      fontSize: 18,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(drafts.length, (index) {
                    Post draft = drafts.elementAt(index);
                    String caption = draft.caption.toString();
                    return Material(
                      key: ValueKey(draft),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {

                        },
                        child: Ink(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                color: Colors.grey.shade50,
                              )),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    caption.isNotEmpty ? caption : 'Photo',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 16),
                                  ),
                                  width: size.width * .6,
                                ),
                                const Spacer(),
                                (draft.contents != null &&
                                        draft.contents!.isNotEmpty)
                                    ? Container(
                                        height: size.width * .2,
                                        width: size.width * .2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              imageUrl +
                                                  draft.contents![0].attachment!
                                                      .name
                                                      .toString(),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
      height: size.height * .7,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
