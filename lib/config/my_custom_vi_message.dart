import 'package:timeago/timeago.dart';

class MyCustomViMessages implements LookupMessages {
  @override
  String aDay(int hours) {
    return '$hours ngày trước';
  }

  @override
  String aboutAMinute(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String aboutAMonth(int days) {
    return '1 tháng trước';
  }

  @override
  String aboutAYear(int year) {
    return '$year năm trước';
  }

  @override
  String aboutAnHour(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String days(int days) {
    return '$days ngày trước';
  }

  @override
  String hours(int hours) {
    return '$hours giờ trước';
  }

  @override
  String lessThanOneMinute(int seconds) {
    return 'Vừa xong';
  }

  @override
  String minutes(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String months(int months) {
    return '$months tháng trước';
  }

  @override
  String prefixAgo() {
    return '';
  }

  @override
  String prefixFromNow() {
    return '';
  }

  @override
  String suffixAgo() {
    return '';
  }

  @override
  String suffixFromNow() {
    return '';
  }

  @override
  String wordSeparator() {
    return ' ';
  }

  @override
  String years(int years) {
    return '$years năm trước';
  }
}
