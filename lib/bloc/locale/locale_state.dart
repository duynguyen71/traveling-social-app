part of 'locale_cubit.dart';

@immutable
abstract class LocaleState {
  final Locale locale;

  const LocaleState(this.locale);
}

class SelectedLocale extends LocaleState {
  const SelectedLocale(Locale locale) : super(locale);
}

