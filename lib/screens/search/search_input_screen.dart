import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/screens/search/search_results.dart';

import '../../constants/app_theme_constants.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/rounded_input_container.dart';

class SearchInputScreen extends StatefulWidget {
  const SearchInputScreen({Key? key}) : super(key: key);

  @override
  State<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen>
    with AutomaticKeepAliveClientMixin {
  final _focusNode = FocusNode();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    Navigator.push(
                            context, SearchResults.route(_searchController))
                        .then((value) => _focusNode.requestFocus());
                    // await _handleSearch();
                  },
                  onChange: (String value) {},
                  focusNode: _focusNode,
                  controller: _searchController,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async => () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResults(
                              searchController: _searchController),
                        ));
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/search.svg",
                    color: Colors.black87,
                  ),
                ),
              ],
              bottom: PreferredSize(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                  ),
                  preferredSize: Size.fromHeight(1)),
            ),
          ];
        },
        body: Stack(
          children: [],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
