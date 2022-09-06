import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:latlong2/latlong.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/models/base_tour.dart';
import 'package:traveling_social_app/models/base_user.dart';
import 'package:traveling_social_app/models/current_user_tour.dart';
import 'package:traveling_social_app/screens/profile/components/icon_with_text.dart';
import 'package:traveling_social_app/screens/tour/tour_map_view.dart';

import '../../bloc/tour/user_tour_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/chat_service.dart';
import '../../utilities/application_utility.dart';
import '../../widgets/base_sliver_app_bar.dart';
import '../../widgets/tap_effect_widget.dart';
import '../../widgets/text_title.dart';
import '../../widgets/user_avt.dart';
import '../message/chat_screen.dart';
import '../profile/profile_screen.dart';
import 'components/tour_request_user.dart';
import 'create_tour_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class CurrentUserTours extends StatefulWidget {
  const CurrentUserTours({Key? key}) : super(key: key);

  @override
  State<CurrentUserTours> createState() => _CurrentUserTourState();

  static Route route() => MaterialPageRoute(
        builder: (context) => const CurrentUserTours(),
      );
}

class _CurrentUserTourState extends State<CurrentUserTours> {
  @override
  void initState() {
    super.initState();
    context.read<UserTourBloc>().add(const GetCurrentTourEvent());
  }

  final _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              BaseSliverAppBar(
                title: 'Tour cua ban',
                isShowLeading: true,
                bottom: PreferredSize(
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade100,
                    ),
                    preferredSize: const Size.fromHeight(1)),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, CreateTourScreen.route());
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<UserTourBloc>().add(InitialTourEvent());
            },
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              shrinkWrap: true,
              children: [
                //
                BlocBuilder<UserTourBloc, UserTourState>(
                  builder: (context, state) {
                    var numOfRequest = state.currentTour?.numOfRequest ?? 0;
                    return (numOfRequest <= 0)
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        '${numOfRequest} Yêu cầu tham gia mới',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ))),
                                TextButton(
                                  onPressed: () async {
                                    _showRequests(
                                        context, state.currentTour!.id!);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Xem',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      letterSpacing: .8,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                ),
                // INFO
                BlocBuilder<UserTourBloc, UserTourState>(
                  builder: (context, state) {
                    var tour = state.currentTour;
                    if (tour == null) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TapEffectWidget(
                          tap: () {
                            _handleTap(context, tour);
                          },
                          child: Card(
                            color: Colors.lightBlue.shade50,
                            borderOnForeground: true,
                            elevation: .9,
                            shadowColor: Colors.lightBlueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.transparent,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: TextTitle(
                                              text: "Đang lên kế hoạch"),
                                        ),
                                        Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ))
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${tour.id} - ${tour.title}',
                                    style: const TextStyle(
                                        fontSize: 14, letterSpacing: .7),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconTextButton(
                                        icon: const Icon(
                                          Icons.supervised_user_circle,
                                        ),
                                        text:
                                            '${tour.tourUsers.length + 1} / ${tour.numOfMember} members',
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextTitle(
                                          text: "Vài thông tin bạn cần lưu ý"),
                                      TourNote(
                                          icon: const Icon(
                                            Icons.card_travel_outlined,
                                          ),
                                          text:
                                              'Ngày khởi hành ${Jiffy((DateTime.parse('${tour.departureDate}'))).format('dd-MM-yyyy HH:mm')}'

                                          // '${calculateTimeDifferenceBetween(startDate: DateTime.now(), endDate: DateTime.parse('${tour.departureDate}'))}',
                                          ),
                                      TourNote(
                                        icon: Icon(
                                          Icons.money,
                                          color: Colors.orangeAccent,
                                        ),
                                        text: '${tour.cost ?? 0} vnd',
                                      ),
                                      TourNote(
                                        icon: Icon(
                                          Icons.date_range,
                                          color: Colors.orangeAccent,
                                        ),
                                        text:
                                            'Số ngày đi ${tour.totalDay ?? 1}',
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          var location =
                                              state.currentTour?.location;
                                          var latLng = LatLng(
                                              location!.latitude!,
                                              location!.longitude!);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TourMapView(
                                                  latLng: latLng,
                                                ),
                                              ));
                                        },
                                        child: TourNote(
                                            icon: Icon(
                                                color: Colors.redAccent,
                                                Icons.location_on_outlined),
                                            text: tour.location!.label ?? ''),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                //MEMBER
                BlocBuilder<UserTourBloc, UserTourState>(
                  builder: (context, state) {
                    var members = state.currentTour?.tourUsers ?? [];
                    return //  MEMBER
                        Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            // elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextTitle(
                                      text:
                                          "Thành viên ${members.length + 1}/${state.currentTour?.numOfMember ?? 0}"),
                                  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        if (index == members.length) {
                                          var user = context
                                              .read<AuthenticationBloc>()
                                              .state
                                              .user;
                                          return TourUserEntry(
                                              id: user.id,
                                              avt: user.avt,
                                              username: "Bạn",
                                              onTapMessage: () {},
                                              showMessage: false);
                                        }
                                        var user = members[index].user!;
                                        var messageGroupId =
                                            members[index].messageGroupId;
                                        return TourUserEntry(
                                            id: user.id!,
                                            username: user.username ?? '',
                                            avt: user.avt,
                                            onTapMessage: () async {
                                              _navigateToMessageScreen(
                                                  messageGroupId, user);
                                            },
                                            showMessage: true);
                                      },
                                      itemCount: members.length + 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                //

                Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  padding: EdgeInsets.all(4.0),
                  child: TextTitle(text: "Đã hoàn thành"),
                  color: Colors.white,
                ),
              ],
            ),
          )),
    );
  }

  void _handleTap(BuildContext context, CurrentUserTour tour) {
    var hostId = tour.host?.id;
    var currentUserId = context.read<AuthenticationBloc>().state.user.id;
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        var isHost = hostId == currentUserId;
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Xem'),
            ),
            isHost
                ? CupertinoActionSheetAction(
                    onPressed: () async {
                      await _getDataAndEdit(context, tour.id!);
                    },
                    child: const Text('Chỉnh sửa'))
                : const SizedBox.shrink(),
            isHost
                ? CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.pop(context);
                      _showRequests(context, tour!.id!);
                    },
                    child: const Text('Duyệt người tham gia'))
                : const SizedBox.shrink(),
            isHost
                ? CupertinoActionSheetAction(
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return TourRequestUser(
                              tourId: tour.id!,
                            );
                          },
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          isDismissible: true);
                    },
                    child: const Text('Đánh dấu hoàn thành'))
                : const SizedBox.shrink(),
            isHost
                ? CupertinoActionSheetAction(
                    onPressed: () async {}, child: const Text('Xóa'))
                : const SizedBox.shrink(),
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

  void _showRequests(BuildContext context, int tourId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return TourRequestUser(
            tourId: tourId,
          );
        },
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true);
  }

  Future<void> _getDataAndEdit(BuildContext context, int tourId) async {
    Navigator.pop(context);
    _handleEditTour(context, tourId);
  }

  void _navigateToMessageScreen(int? messageGroupId, BaseUserInfo user) async {
    if (messageGroupId != null) {
      Navigator.push(context,
          ChatScreen.route(groupId: messageGroupId, name: user.username ?? ''));
      return;
    } else {
      var group = await _chatService.getChatGroupBetweenTwoUsers(user.id!);
      Navigator.push(context,
          ChatScreen.route(groupId: group!.id!, name: user.username ?? ''));
    }
  }

  void _handleEditTour(BuildContext context, int id) {
    Navigator.push(context, CreateTourScreen.route());
    context.read<UserTourBloc>().add(UpdateTourRequestEvent(id));
  }

  static String calculateTimeDifferenceBetween(
      {required DateTime startDate, required DateTime endDate}) {
    int seconds = (-endDate.difference(startDate).inSeconds);
    if (seconds < 60) {
      return '$seconds giây';
    } else if (seconds >= 60 && seconds < 3600) {
      return '${startDate.difference(endDate).inMinutes.abs()} phút';
    } else if (seconds >= 3600 && seconds < 86400) {
      return '${startDate.difference(endDate).inHours} giờ';
    } else {
      return '${startDate.difference(endDate).inDays} ngày';
    }
  }
}

class TourNote extends StatelessWidget {
  const TourNote({Key? key, required this.icon, required this.text})
      : super(key: key);
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(text),
        ],
      ),
    );
  }
}

class TourUserEntry extends StatelessWidget {
  const TourUserEntry(
      {Key? key,
      this.avt,
      required this.id,
      required this.username,
      required this.onTapMessage,
      required this.showMessage})
      : super(key: key);
  final String? avt;
  final int id;
  final String username;
  final Function onTapMessage;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(
          avt: avt,
          size: 35,
          onTap: () {
            Navigator.push(
              context,
              ProfileScreen.route(id),
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: Text(username)),
        Visibility(
          visible: showMessage,
          child: IconButton(
              onPressed: () {
                onTapMessage();
              },
              icon: const Icon(
                Icons.messenger,
                color: Colors.lightBlueAccent,
              )),
        )
      ],
    );
  }
}
