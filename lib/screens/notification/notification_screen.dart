import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/bloc/notification/notification_bloc.dart';
import 'package:traveling_social_app/bloc/notification/notification_event.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/widgets/base_sliver_app_bar.dart';
import 'package:traveling_social_app/widgets/empty_mesage_widget.dart';
import 'package:traveling_social_app/widgets/user_avt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;

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
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [const BaseSliverAppBar(title: 'Notifications', actions: [])];
      },
      body: Center(
        child: EmptyMessageWidget(
          message: AppLocalizations.of(context)!.notInformation,
          icon: Transform.rotate(
            angle: -math.pi / 6,
            child: SvgPicture.asset('assets/icons/notification.svg',
                color: Colors.black54),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
