import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/setting/components/setting_item_selected.dart';
import 'package:traveling_social_app/widgets/my_divider.dart';

class LanguageSettingScreen extends StatelessWidget {
  const LanguageSettingScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const LanguageSettingScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
            ),
            Text(
              'Setting',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
        leadingWidth: 200,
        title: Text(
          'Language',
          style: TextStyle(
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
                children: const [
                  SettingItemSelected(
                    text: "Vietnamese",
                    isChecked: false,
                  ),
                  MyDivider(),
                  SettingItemSelected(
                    text: "English",
                    isChecked: true,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
