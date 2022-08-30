import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/bloc/notification/notification_bloc.dart';
import 'package:traveling_social_app/bloc/notification/notification_event.dart';
import 'package:traveling_social_app/bloc/notification/notification_state.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:traveling_social_app/widgets/empty_mesage_widget.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(FetchNotification());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.read<NotificationBloc>().add(FetchNotification());
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          BaseSliverAppBar(
            title: 'Thông báo',
            actions: [],
            bottom: PreferredSize(
                child: Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                preferredSize: Size.fromHeight(1)),
          ),
        ];
      },
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Stack(
          children: [
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                var notifications = state.notifications;
                return notifications.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var notification = notifications[index];
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserAvatar(
                                  size: 40,
                                  avt: notification.user?.avt,
                                  onTap: () => Navigator.push(
                                      context,
                                      ProfileScreen.route(
                                          notification!.user!.id!)),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(notification.message.toString()),
                                        Text(
                                          timeago.format(
                                              DateTime.parse(notification
                                                  .createDate
                                                  .toString()),
                                              locale: Localizations.localeOf(
                                                      context)
                                                  .languageCode),
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: notifications.length,
                      )
                    : Center(
                        child: EmptyMessageWidget(
                          message: AppLocalizations.of(context)!.notInformation,
                          icon: Transform.rotate(
                            angle: -math.pi / 6,
                            child: SvgPicture.asset(
                                'assets/icons/notification.svg',
                                color: Colors.black54),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
