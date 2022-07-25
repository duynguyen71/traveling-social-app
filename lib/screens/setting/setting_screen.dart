import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/setting/components/setting_item_checkbox.dart';
import 'package:traveling_social_app/screens/setting/components/setting_item_with_more_icon.dart';
import 'package:traveling_social_app/screens/setting/language_setting_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();

  static Route route() =>
      MaterialPageRoute<void>(builder: (context) => const SettingScreen());
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            letterSpacing: 1,
            fontWeight: FontWeight.w500),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingItemWithMoreIcon(
                    isLast: false,
                    title: 'Appearance',
                    icon: Icons.settings,
                    description: 'Make TC Social\'s Your',
                    onClick: () {},
                    asset: 'assets/icons/language.svg',
                  ),
                  SettingItemWithMoreIcon(
                    isLast: false,
                    title: 'Privacy',
                    icon: Icons.settings,
                    description: 'description',
                    leadingBg: Colors.yellow,
                    onClick: () {},
                    asset: 'assets/icons/privacy.svg',
                  ),
                  SettingItemWithMoreIcon(
                    isLast: true,
                    title: 'Language',
                    icon: Icons.settings,
                    description: 'description',
                    onClick: () {
                      Navigator.push(context, LanguageSettingScreen.route());
                    },
                    asset: 'assets/icons/language.svg',
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingItemWithMoreIcon(
                    isLast: false,
                    title: 'Appearance',
                    icon: Icons.settings,
                    description: 'Make TC Social\'s Your',
                    onClick: () {},
                    asset: 'assets/icons/language.svg',
                  ),
                  SettingItemWithMoreIcon(
                    isLast: true,
                    title: 'Apperace',
                    icon: Icons.settings,
                    description: 'description',
                    onClick: () {},
                    asset: 'assets/icons/language.svg',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: const SettingItemCheckBox(
                isLast: true,
                icon: Icons.mode,
                title: 'Dark mode',
                description: 'Automatic',
                leadingBg: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
