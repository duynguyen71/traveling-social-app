import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/BaseUserInfo.dart';
import 'package:traveling_social_app/screens/profile/profile_screen.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/custom_input_field.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';

import '../../constants/api_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.keyword}) : super(key: key);

  final String? keyword;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final UserService _userService = UserService();
  final _focusNode = FocusNode();
  final Set<BaseUserInfo> _users = <BaseUserInfo>{};
  bool _isNotFound = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.keyword.toString();
    _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length));
    _focusNode.requestFocus();
  }

  _handleSearch() async {
    String keyword = _searchController.text.toString().trim().toLowerCase();
    setState(() {
      _users.clear();
      _isNotFound = false;
    });
    if (keyword.isNotEmpty) {
      final users = await _userService.searchUsers(
          username: keyword, phone: keyword, email: keyword);
      if (users.isNotEmpty) {
        setState(() {
          _users.addAll(users);
          _isNotFound = false;
        });
        _scrollController.animateTo(0,
            curve: Curves.linear, duration: Duration.zero);
      } else {
        setState(() {
          _isNotFound = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: kPrimaryColor,
                ),
              ),
              bottom:  PreferredSize(
                preferredSize: const Size(double.infinity, 1),
                child: Divider(
                  color: kPrimaryColor.withOpacity(.2),
                  height: 1,
                ),
              ),
              title: RoundedInputContainer(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                color: Colors.black12,
                child: CustomInputField(
                  onChange: (String value) {
                    if (value.isEmpty) {
                      setState(() {
                        _users.clear();
                        _isNotFound = false;
                      });
                    }
                  },
                  focusNode: _focusNode,
                  controller: _searchController,
                ),
              ),
              pinned: true,
              actions: [
                IconButton(
                  onPressed: _handleSearch,
                  icon: const Icon(Icons.search, color: kPrimaryLightColor),
                ),
              ],
            ),
          ];
        },
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: (_isNotFound && _users.isEmpty)
                ? Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .4,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Oops We Couldn’t Find Matching Credential :(',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: _users
                  .map((e) =>
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        ApplicationUtility.navigateToScreen(
                            context, ProfileScreen(userId: e.id!));
                      },
                      child: Ink(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    clipBehavior: Clip.hardEdge,
                                    child: FittedBox(
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.hardEdge,
                                        child: e.avt != null
                                            ? CachedNetworkImage(
                                          imageUrl: imageUrl +
                                              e.avt.toString(),
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          'assets/images/blank-profile-picture.png',
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(e.username.toString()),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon:
                                      const Icon(Icons.person_add_alt)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
                  .toList(),
            ),
          ),
        ], controller: _scrollController,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
