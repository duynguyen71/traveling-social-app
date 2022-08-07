import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    print('bookmark init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            BaseSliverAppBar(
                title: AppLocalizations.of(context)!.bookmark, actions: const[])
          ];
        },
        body: Container(
          color: Colors.grey.shade50,
          child: Column(),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
