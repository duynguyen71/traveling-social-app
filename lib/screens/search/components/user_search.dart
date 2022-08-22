import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/screens/search/components/search_result_list_container.dart';

import '../../../constants/api_constants.dart';
import '../../../models/base_user.dart';
import '../../../services/user_service.dart';
import '../../../utilities/application_utility.dart';
import '../../../widgets/my_divider.dart';
import '../../profile/profile_screen.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({Key? key, this.keyWord}) : super(key: key);
  final String? keyWord;

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch>
    with AutomaticKeepAliveClientMixin {
  List<BaseUserInfo> _users = [];

  final _userService = UserService();

  bool _isLoading = true;

  set isLoading(i) => setState(() => _isLoading = i);

  @override
  void didChangeDependencies() {
    ApplicationUtility.hideKeyboard();
    _getUsers();
    super.didChangeDependencies();
  }

  _getUsers() async {
    try {
      isLoading = true;
      var users = await _userService.searchUsers(username: widget.keyWord);
      setState(() => _users = users);
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SearchResultListContainer(
            isLoading: _isLoading,
            child: (c) {
              var user = c as BaseUserInfo;
              return Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    ApplicationUtility.navigateToScreen(
                        context, ProfileScreen(userId: user.id!));
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
                                    child: user.avt != null
                                        ? CachedNetworkImage(
                                            imageUrl: '$imageUrl${user.avt}',
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(user.username.toString()),
                                ],
                              ),
                              const Spacer(),
                              user.isFollowing
                                  ? const SizedBox.shrink()
                                  : IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.person_add_alt)),
                            ],
                          ),
                        ),
                        const MyDivider(width: 1),
                      ],
                    ),
                  ),
                ),
              );
            },
            list: _users,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
