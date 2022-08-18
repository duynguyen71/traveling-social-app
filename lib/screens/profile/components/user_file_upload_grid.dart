import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/services/post_service.dart';

import '../../../models/file_upload.dart';

class UserFileUploadGrid extends StatefulWidget {
  const UserFileUploadGrid({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<UserFileUploadGrid> createState() => _UserFileUploadGridState();
}

class _UserFileUploadGridState extends State<UserFileUploadGrid>
    with AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  final List<FileUpload> _files = [];
  bool _hasReachMax = false;
  int _page = 0;
  bool _isLoading = false;

  _fetchFiles() {
    if (_hasReachMax || _isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _postService
        .getUserFileUploads(widget.userId, page: _page, pageSize: 15)
        .then((value) {
      if (value.isEmpty) {
        setState(() {
          _hasReachMax = true;
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _files.addAll(value);
        _isLoading = false;
        _page += 1;
      });
    });
  }

  @override
  void initState() {
    _fetchFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        var position = scrollNotification.metrics;
        if (position.pixels == position.maxScrollExtent) {
          _fetchFiles();
          return true;
        }
        return false;
      },
      child: GridView.count(
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        children: _files
            .map((e) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  height: 180,
                  // child: CachedNetworkImage(
                  //   imageUrl: '$imageUrl${e.name}',
                  //   fit: BoxFit.cover,
                  // ),
                  child: Image.network(
                    '$imageUrl${e.name}',
                    cacheHeight: 180,
                    // cacheWidth: 180,

                    fit: BoxFit.fitHeight,
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
