import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../constants/app_theme_constants.dart';
import '../../models/tour_detail.dart';
import '../../services/post_service.dart';
import '../../widgets/user_avt.dart';
import '../create_review/components/review_post_title.dart';
import '../profile/components/icon_with_text.dart';
import '../profile/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../tour/current_user_tours.dart';

class TourDetailScree extends StatefulWidget {
  const TourDetailScree({Key? key, required this.tourId}) : super(key: key);
  final int tourId;

  @override
  State<TourDetailScree> createState() => _TourDetailScreeState();

  static Route route({required int tourId}) => MaterialPageRoute(
        builder: (context) => TourDetailScree(
          tourId: tourId,
        ),
      );
}

class _TourDetailScreeState extends State<TourDetailScree> {
  bool _isFetching = false;
  late TourDetail _tour;
  final _postService = PostService();

  set isLoading(bool i) => setState(() {
        _isFetching = i;
      });

  getTour() async {
    isLoading = true;
    final tour = await _postService.getTourDetail(id: widget.tourId);
    if (tour == null) Navigator.pop(context);
    setState(() => _tour = tour!);
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    getTour();
  }

  bool isHost(){
    return (_tour.host?.id==context.read<AuthenticationBloc>().state.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        body: RefreshIndicator(
          onRefresh: () async {},
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                    addAutomaticKeepAlives: true,
                    shrinkWrap: false,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: [
                      _isFetching
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            )
                          : Column(
                              children: [
                                // POST TITLE
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ReviewPostTitle(
                                    title: _tour.title ?? '',
                                    padding: const EdgeInsets.only(top: 8.0),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // LOCATION
                                    _tour.location != null
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: IconTextButton(
                                              text: '${_tour.location?.label}',
                                              icon: const Icon(
                                                color: Colors.redAccent,
                                                Icons.location_on,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    // COUNT VIEWER
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(50, 30),
                                          alignment: Alignment.centerRight,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap),
                                      onPressed: () {},
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                                '${_tour.joinedMember} / ${_tour.numOfMember} thành viên',
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          ),
                                          const Icon(
                                            Icons.supervised_user_circle_sharp,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                TourNote(
                                  icon: Icon(
                                    Icons.date_range,
                                    color: Colors.orangeAccent,
                                  ),
                                  text: 'Số ngày đi ${_tour.totalDay ?? 1}',
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child:Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.0,),
                                    child:  Text(
                                      _tour.content ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      constraints: BoxConstraints(minWidth: 100),
                                      margin: EdgeInsets.all(18.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Colors.grey.shade50),
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Yêu cầu tham gia',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              letterSpacing: .6,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        style: TextButton.styleFrom(
                                          elevation: 0,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: const Size(100, 30),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    )),
                              ],
                            ),

                      // SPACER
                      const SizedBox(
                        height: 100,
                      ),
                    ]),
              ),
            ],
          ),
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black54,
                ),
              ),
              leadingWidth: 25,
              pinned: true,
              centerTitle: false,
              title: _isFetching
                  ? const SizedBox.shrink()
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UserAvatar(
                              size: 40,
                              avt: '${_tour.host!.avt}',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    ProfileScreen.route(
                                      _tour.host!.id!,
                                    ));
                              }),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _tour.host!.username!,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                                Text(
                                  timeago.format(
                                      DateTime.parse(
                                          _tour.createDate.toString()),
                                      locale: Localizations.localeOf(context)
                                          .languageCode),
                                  style: const TextStyle(
                                      color: Colors.black26, fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              elevation: 0,
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.grey.shade200,
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(1)),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.black38,
                )
              ],
            )
          ];
        },
      ),
    );
  }
}
