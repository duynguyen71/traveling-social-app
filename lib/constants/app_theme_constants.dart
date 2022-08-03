import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF3E4067);
const kTextColor = Color(0xFF3F4168);
const kIconColor = Color(0xFF5E5E5E);
const kPrimaryLightColor = Color.fromRGBO(134, 122, 233, 1);

const kDefaultPadding = 20.0;
const kDefaultHorizPadding = EdgeInsets.symmetric(horizontal: 8.0);
const kDefaultListItemPadding =
    EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
final kDefaultShadow = BoxShadow(
  offset: const Offset(5, 5),
  blurRadius: 10,
  color: const Color(0xFFE9E9E9).withOpacity(0.56),
);
final kDefaultPostActionBarShadow = BoxShadow(
  offset: const Offset(4, 5),
  blurRadius: 6,
  color: const Color(0xFFE9E9E9).withOpacity(0.5),
);

const kImg =
    "https://images.pexels.com/photos/6977499/pexels-photo-6977499.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";

const kLoginPrimaryColor = Color(0xFF6A62B7);
const kLoginPrimaryLightColor = Color(0xFFE5E5E5);
const weatherAPIKey = "ad84ccee2e8fcc04efbf74a5a6d5f91a";

const kbottomSheetBackgroundColor = Color.fromRGBO(247, 247, 247, 1);

const kChatControllerHeight = 60.0;
const kChatAppBarHeight = 68.0;

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

const kIconPadding = 4.0;
const kIconSize = 25.0;
const kDefaultBottomNavIconSize = 24.0;

const kDefaultAppBarTextTitleStyle =
    TextStyle(color: Colors.black87, letterSpacing: .6, fontSize: 18);

const kDefaultStoryCardHeight = 180.0;
const kMainBottomNavHeight = 60.0;
