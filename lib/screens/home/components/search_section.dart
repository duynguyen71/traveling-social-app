import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/search/search_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({Key? key}) : super(key: key);

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  late AssetImage _assetImage;

  @override
  void didChangeDependencies() {
    _assetImage = const AssetImage('assets/images/home_bg.png');
    precacheImage(_assetImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[100],
      constraints: const BoxConstraints(minHeight: 250),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          buildBackground(size),
          const Positioned(
            bottom: -5,
            left: 0,
            right: 0,
            child: MySearchBox(),
          ),
        ],
      ),
    );
  }

  Container buildBackground(Size size) {
    return Container(
      height: size.height * .3,
      constraints: const BoxConstraints(minHeight: 250),
      decoration: BoxDecoration(
        image: DecorationImage(image: _assetImage, fit: BoxFit.cover),
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travelers".toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class MySearchBox extends StatefulWidget {
  const MySearchBox({
    Key? key,
  }) : super(key: key);

  @override
  State<MySearchBox> createState() => _MySearchBoxState();
}

class _MySearchBoxState extends State<MySearchBox> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (text) {},
            decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
        GestureDetector(
          onTap: () {
            ApplicationUtility.navigateToScreen(
                context,
                SearchScreen(
                  keyword: _searchController.text.toString(),
                ));
          },
          child: SvgPicture.asset(
            "assets/icons/search.svg",
            color: kPrimaryColor,
          ),
        )
      ]),
    );
  }
}
