import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/screens/explore/tour_detail_screen.dart';
import '../../bloc/tour/user_tour_bloc.dart';
import '../../models/base_tour.dart';

import '../../services/post_service.dart';
import '../../widgets/tap_effect_widget.dart';
import '../tour/current_user_tours.dart';
import '../tour/tour_map_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;

class TourScreen extends StatefulWidget {
  const TourScreen({Key? key}) : super(key: key);

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen>
    with AutomaticKeepAliveClientMixin {
  final _postService = PostService();
  List<BaseTour> _tours = [];

  @override
  void initState() {
    super.initState();
    context.read<UserTourBloc>().add(const GetCurrentTourEvent());
    getTours();
  }

  void getTours() {
    _postService.getTours().then((value) {
      setState(() => _tours = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        getTours();
      },
      child: NotificationListener<ScrollNotification>(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            // List random review post
            SliverToBoxAdapter(
              child: Container(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var t = _tours[index];
                      if (index >= 5) {
                        return const SizedBox();
                      }
                      return TapEffectWidget(
                        tap: () {
                          Navigator.push(
                              context, TourDetailScree.route(tourId: t.id!));
                        },
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        t.title ?? '',
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    var location = t.location;
                                    if (location == null) return;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TourMapView(
                                            latLng: LatLng(location.latitude!,
                                                location.longitude!),
                                          ),
                                        ));
                                  },
                                  child: TourNote(
                                      icon: const Icon(
                                          color: Colors.redAccent,
                                          Icons.location_on_outlined),
                                      text: t.location!.label ?? ''),
                                ),
                                TourNote(
                                  icon: const Icon(
                                    Icons.supervised_user_circle_sharp,
                                  ),
                                  text:
                                      '${t.joinedMember} / ${t.numOfMember} thành viên',
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    timeago.format(
                                        DateTime.parse(t.createDate.toString()),
                                        locale: Localizations.localeOf(context).languageCode),
                                    style: TextStyle(
                                        color: Colors.grey[800], fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _tours.length,
                    shrinkWrap: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
