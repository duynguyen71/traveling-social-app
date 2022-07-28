import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:traveling_social_app/config/my_custom_vi_message.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  //default en language
  final _storage = const FlutterSecureStorage();

  LocaleCubit() : super(const SelectedLocale(Locale('en'))) {
    _storage.read(key: "localeName").then((value) {
      if (value != null) {
        return emit(SelectedLocale(Locale(value)));
      }
    });
  }

  void toEnglish() => emit(const SelectedLocale(Locale('en')));

  void toVietnamese() => emit(const SelectedLocale(Locale('vi')));

  void toLocaleName(String locale) => emit(SelectedLocale(Locale(locale)));

  @override
  void onChange(Change<LocaleState> change) async {
    if (change.nextState.locale.languageCode == 'vi') {
      timeago.setLocaleMessages('vi', MyCustomViMessages());
    } else {
      timeago.setLocaleMessages('en', timeago.EnMessages());
    }
    super.onChange(change);
  }
}
