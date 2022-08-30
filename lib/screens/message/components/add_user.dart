import 'package:flutter/material.dart';

import '../../../models/base_user.dart';
import '../../../services/user_service.dart';
import '../../../widgets/my_outline_button.dart';
import '../../../widgets/rounded_input_container.dart';
import '../../../widgets/user_avt.dart';
import '../../profile/profile_screen.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key, required this.onAddUser}) : super(key: key);
final Function(BaseUserInfo user) onAddUser;
  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _userService = UserService();
  List<BaseUserInfo> _users = [];
  List<BaseUserInfo> _filter = [];

  @override
  void initState() {
    super.initState();
    _userService
        .getFollowing(page: 0, pageSize: 10)
        .then((value) => setState(() {
              _users = value;
              _filter = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .9,
      minChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200))),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Thêm thành viên',
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
              Container(
                child: RoundedInputContainer(
                  color: Colors.grey.shade100,
                  child: TextField(
                    // controller: _searchController,
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _filter = _users;
                        });
                      }
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _filter = [..._users.where((element) => element.username!.toLowerCase().contains(value))];
                      });
                    },
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: 'Nhập tên thành viên',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      hintStyle: TextStyle(
                        letterSpacing: .5,
                        fontSize: 14,
                        // fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.zero,
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20,),
                itemBuilder: (context, index) {
                  var user = _filter[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade100))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    child: Row(
                      children: [
                        UserAvatar(
                          size: 40,
                          avt: user.avt,
                          onTap: () => Navigator.push(
                            context,
                            ProfileScreen.route(user.id!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text('${user.username}')),
                        MyOutlineButton(
                          onClick: () async {
                            widget.onAddUser(user);
                          },
                          text: 'Thêm',
                        ),
                      ],
                    ),
                  );
                },
                itemCount: _filter.length,
                shrinkWrap: true,
              )
            ],
          ),
        );
      },
    );
  }
}
