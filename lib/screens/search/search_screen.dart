import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/widgets/custom_input_field.dart';
import 'package:traveling_social_app/widgets/my_app_bar.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.keyword}) : super(key: key);

  final String? keyword;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.text = widget.keyword.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 1),
          child: Divider(
            color: kPrimaryColor.withOpacity(.2),
            height: 1,
          ),
        ),
        primary: false,
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
          child: CustomInputField(
            onChange: (String value) {},
            controller: _searchController,
          ),
        ),
        titleSpacing: 3,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: kPrimaryLightColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
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
