import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/bloc/locale/locale_cubit.dart';
import 'package:traveling_social_app/models/language.dart';
import 'package:traveling_social_app/screens/setting/components/setting_item_checkbox.dart';
import 'package:traveling_social_app/screens/setting/components/setting_item_selected.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const NotificationSettingScreen());

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  final _storage = const FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              constraints:const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.setting,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
        leadingWidth: 200.0,
        title: Text(
          AppLocalizations.of(context)!.notification,
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
