import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/bloc/notification/notification_bloc.dart';
import 'package:traveling_social_app/bloc/notification/notification_event.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';

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
    print("=== Notification Screen ===");
    context.read<NotificationBloc>().add(FetchNotification());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    super.build(context);
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [const BaseSliverAppBar(title: 'Notifications', actions: [])];
      },
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        height: size.height,
        color: Colors.grey.shade50,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration:
                  BoxDecoration(color: kPrimaryLightColor.withOpacity(.1)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAvatar(size: 50, avt: null, onTap: () {}),
                      const SizedBox(width: 10),
                      RichText(
                        text: const TextSpan(
                            text: 'username ',
                            children: [
                              TextSpan(
                                text: 'updae isfdsf',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                            style: TextStyle(
                                // letterSpacing: 1,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)),
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      )
                    ],
                  )),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                  // Column(
                  //   children: [],
                  // )
                ],
              ),
            )
          ],
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
