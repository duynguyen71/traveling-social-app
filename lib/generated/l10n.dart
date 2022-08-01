// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Post`
  String get post {
    return Intl.message(
      'Post',
      name: 'post',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Story`
  String get story {
    return Intl.message(
      'Story',
      name: 'story',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Love`
  String get love {
    return Intl.message(
      'Love',
      name: 'love',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `My Feed`
  String get myFeed {
    return Intl.message(
      'My Feed',
      name: 'myFeed',
      desc: '',
      args: [],
    );
  }

  /// `TC Social`
  String get title {
    return Intl.message(
      'TC Social',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark`
  String get bookmark {
    return Intl.message(
      'Bookmark',
      name: 'bookmark',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message(
      'Privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Make TC Social's Your`
  String get settingAppearanceDescription {
    return Intl.message(
      'Make TC Social\'s Your',
      name: 'settingAppearanceDescription',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Select your app language`
  String get settingLanguageDescription {
    return Intl.message(
      'Select your app language',
      name: 'settingLanguageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logOut {
    return Intl.message(
      'Logout',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `About us`
  String get aboutUs {
    return Intl.message(
      'About us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Show more`
  String get showMore {
    return Intl.message(
      'Show more',
      name: 'showMore',
      desc: '',
      args: [],
    );
  }

  /// `Show less`
  String get showLess {
    return Intl.message(
      'Show less',
      name: 'showLess',
      desc: '',
      args: [],
    );
  }

  /// `TC Login`
  String get tcLogin {
    return Intl.message(
      'TC Login',
      name: 'tcLogin',
      desc: '',
      args: [],
    );
  }

  /// `TC Register`
  String get tcRegister {
    return Intl.message(
      'TC Register',
      name: 'tcRegister',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have account`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have account',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Don't have account`
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t have account',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Username or password is not correct`
  String get badCredentials {
    return Intl.message(
      'Username or password is not correct',
      name: 'badCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Email have already existed`
  String get emailExist {
    return Intl.message(
      'Email have already existed',
      name: 'emailExist',
      desc: '',
      args: [],
    );
  }

  /// `Username have already existed`
  String get usernameExist {
    return Intl.message(
      'Username have already existed',
      name: 'usernameExist',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfile {
    return Intl.message(
      'Edit profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Follower`
  String get follower {
    return Intl.message(
      'Follower',
      name: 'follower',
      desc: '',
      args: [],
    );
  }

  /// `Following`
  String get following {
    return Intl.message(
      'Following',
      name: 'following',
      desc: '',
      args: [],
    );
  }

  /// `Joined at {formatDate}`
  String joinedDate(String formatDate) {
    return Intl.message(
      'Joined at $formatDate',
      name: 'joinedDate',
      desc: 'The date user joined.',
      args: [formatDate],
    );
  }

  /// `Notifications`
  String get notification {
    return Intl.message(
      'Notifications',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Live in`
  String get liveIn {
    return Intl.message(
      'Live in',
      name: 'liveIn',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get position {
    return Intl.message(
      'Position',
      name: 'position',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `New photo from gallery`
  String get newPhotoFromGallery {
    return Intl.message(
      'New photo from gallery',
      name: 'newPhotoFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `New photo from camera`
  String get newPhotoFromCamera {
    return Intl.message(
      'New photo from camera',
      name: 'newPhotoFromCamera',
      desc: '',
      args: [],
    );
  }

  /// `Create post`
  String get createPost {
    return Intl.message(
      'Create post',
      name: 'createPost',
      desc: '',
      args: [],
    );
  }

  /// `Create story`
  String get createStory {
    return Intl.message(
      'Create story',
      name: 'createStory',
      desc: '',
      args: [],
    );
  }

  /// `Create review post`
  String get createReviewPost {
    return Intl.message(
      'Create review post',
      name: 'createReviewPost',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Type in your text`
  String get typeInYourText {
    return Intl.message(
      'Type in your text',
      name: 'typeInYourText',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get follow {
    return Intl.message(
      'Follow',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Search in chat`
  String get searchInChat {
    return Intl.message(
      'Search in chat',
      name: 'searchInChat',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get drafts {
    return Intl.message(
      'Draft',
      name: 'drafts',
      desc: '',
      args: [],
    );
  }

  /// `What are you thinking?`
  String get whatRUT {
    return Intl.message(
      'What are you thinking?',
      name: 'whatRUT',
      desc: '',
      args: [],
    );
  }

  /// `Add location`
  String get addLocation {
    return Intl.message(
      'Add location',
      name: 'addLocation',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get posting {
    return Intl.message(
      'Post',
      name: 'posting',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
