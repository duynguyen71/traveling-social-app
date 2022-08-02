import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traveling_social_app/bloc/locale/locale_cubit.dart';
import 'package:traveling_social_app/models/language.dart';
import 'package:traveling_social_app/screens/setting/components/setting_item_selected.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:traveling_social_app/widgets/base_app_bar.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const LanguageSettingScreen());

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  List<Language> languageList = [
    const Language('Vietnamese', 'vi'),
    const Language('English', 'en'),
  ];

  late String selectedLocaleName;

  final _storage = const FlutterSecureStorage();

  @override
  void didChangeDependencies() {
    String localeName = AppLocalizations.of(context)!.localeName;
    setState(() {
      selectedLocaleName = localeName;
    });
    super.didChangeDependencies();
  }

  //method to change app locale
  Future<void> changeLocale(Language e, BuildContext context) async {
    if (AppLocalizations.delegate.isSupported(Locale(e.localName))) {
      await _storage.write(key: 'localeName', value: e.localName);
      context.read<LocaleCubit>().toLocaleName(e.localName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: BaseAppBar(
        title: AppLocalizations.of(context)!.language,
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
                children: languageList.map((e) {
                  return SettingItemSelected(
                    text: e.locale,
                    isChecked: e.localName == selectedLocaleName,
                    onClick: () async {
                      await changeLocale(e, context);
                    },
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
