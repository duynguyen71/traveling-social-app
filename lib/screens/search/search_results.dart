import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/services/user_service.dart';
import 'package:traveling_social_app/widgets/custom_input_field.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';

import '../../models/base_user.dart';
import '../../my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/post_search.dart';
import 'components/user_search.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key, required this.searchController})
      : super(key: key);

  final TextEditingController searchController;

  @override
  State<SearchResults> createState() => _SearchResultsState();

  static Route route(TextEditingController searchController) =>
      MaterialPageRoute(
          builder: (_) => SearchResults(searchController: searchController));
}

class _SearchResultsState extends State<SearchResults>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  Set<BaseUserInfo> _users = {};
  final _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: 2,
        initialIndex: 0,
        animationDuration: Duration.zero);
  }


  _handleSearch() async {
    String keyword =
        widget.searchController.text.toString().trim().toLowerCase();
    if (keyword.isEmpty) return;
    var users = await _userService.searchUsers(
        username: keyword, phone: keyword, email: keyword);
    setState(() {
      _users = ({...users});
    });
    _scrollController.animateTo(0,
        curve: Curves.linear, duration: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Colors.white,
              pinned: true,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(25),
                //TAB BAR
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200))),
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.black87,
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                    indicatorPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 1,
                    labelStyle: MyTheme.heading2.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(
                        height: 18,
                        text: "Users",
                      ),
                      Tab(
                        height: 18,
                        text: "Posts",
                      ),
                    ],
                  ),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: kPrimaryColor,
                ),
              ),
              title: RoundedInputContainer(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                color: Colors.black12,
                child: CustomInputField(
                  hintText: AppLocalizations.of(context)!.searchTCSocial,
                  textInputAction: TextInputAction.go,
                  onSubmit: (value) async {
                    await _handleSearch();
                  },
                  onChange: (String value) {
                    Navigator.of(context).pop();
                    return;
                  },
                  controller: widget.searchController,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async => await _handleSearch(),
                  icon: SvgPicture.asset(
                    "assets/icons/search.svg",
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children:  [
            UserSearch(keyWord: widget.searchController.text,),
            PostSearch(keyWord:widget.searchController.text),
          ],
        ),
      ),
    );
  }


}
